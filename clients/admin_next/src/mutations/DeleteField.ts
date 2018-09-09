import { commitMutation, graphql } from "react-relay";
import { RecordSourceSelectorProxy } from "relay-runtime";
import environment from "../helpers/relay";

const mutation = graphql`
  mutation DeleteFieldMutation($input: DeleteFieldInput!) {
    deleteField(input:$input) {
      success
      confirm
      message
      userErrors {
        field
        message
      }
    }
  }
`;

function updater(store: RecordSourceSelectorProxy) {
  const root = store.getRoot();
  const payload = store.getRootField("deleteField");

  const input = JSON.parse(
    payload!.getDataID()
      .replace("client:root:deleteField(input:", "")
      .replace(")", "")
  );

  const fields = root.getLinkedRecords("fields") || [];
  const newFields = fields.filter((f) => f!.getDataID() !== input.id);

  root.setLinkedRecords(newFields, "fields");
}

function commit(
  variables: DeleteFieldMutationVariables,
) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      return commitMutation(
        environment,
        {
          mutation,
          variables,
          updater,
          onCompleted: (response: DeleteFieldMutationResponse) => {
            resolve(response.deleteField as MutationResult);
          },
          onError: (error) => {
            reject(error);
          }
        },
      );
    }
  );
}

export default { commit };
