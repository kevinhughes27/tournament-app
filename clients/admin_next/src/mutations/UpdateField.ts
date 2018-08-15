import { commitMutation, graphql } from "react-relay";
import environment from "../relay";
import { RecordSourceSelectorProxy } from "relay-runtime";

const mutation = graphql`
  mutation UpdateFieldMutation($input: UpdateFieldInput!) {
    updateField(input:$input) {
      field {
        id
        name
        lat
        long
        geoJson
      }
      success
      message
      userErrors {
        field
        message
      }
    }
  }
`;

function getOptimisticResponse(variables: UpdateFieldMutationVariables) {
  return {
    updateField: {
      ...variables
    },
  };
}

function updater(store: RecordSourceSelectorProxy) {
  const root = store.getRoot();
  const payload = store.getRootField("updateField");

  if (root && payload) {
    const fields = root.getLinkedRecords("fields")! || [];
    const updatedField = payload.getLinkedRecord("field");
    const idx = fields.findIndex((f) => f!.getDataID() === updatedField!.getDataID());
    const newFields = Object.assign([], fields, {[idx]: updatedField});
    root.setLinkedRecords(newFields, "fields");
  }
}

function commit(
  variables: UpdateFieldMutationVariables
) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      commitMutation(
        environment,
        {
          mutation,
          variables,
          updater,
          optimisticResponse: getOptimisticResponse(variables),
          onCompleted: (response: UpdateFieldMutationResponse) => {
            resolve(response.updateField as MutationResult);
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
