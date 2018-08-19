import { commitMutation, graphql } from "react-relay";
import environment from "../relay";
import { RecordSourceSelectorProxy } from "relay-runtime";

const mutation = graphql`
  mutation CreateFieldMutation($input: CreateFieldInput!) {
    createField(input:$input) {
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

function getOptimisticResponse(variables: CreateFieldMutationVariables) {
  return {
    createField: {
      ...variables
    },
  };
}

function updater(store: RecordSourceSelectorProxy) {
  const root = store.getRoot();
  const payload = store.getRootField("createField");

  if (root && payload) {
    const fields = root.getLinkedRecords("fields") || [];
    const newField = payload.getLinkedRecord("field");
    const newFields = [...fields, newField];

    root.setLinkedRecords(newFields, "fields");
  }
}

function commit(
  variables: CreateFieldMutationVariables
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
          onCompleted: (response: CreateFieldMutationResponse) => {
            resolve(response.createField as MutationResult);
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
