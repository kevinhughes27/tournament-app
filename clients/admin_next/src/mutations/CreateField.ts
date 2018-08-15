import { commitMutation, graphql } from "react-relay";
import environment from "../relay";

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
