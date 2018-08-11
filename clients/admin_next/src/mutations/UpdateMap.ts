import { commitMutation, graphql } from "react-relay";
import environment from "../relay";

const mutation = graphql`
  mutation UpdateMapMutation($input: UpdateMapInput!) {
    updateMap(input:$input) {
      success
      message
    }
  }
`;

function getOptimisticResponse(variables: UpdateMapMutationVariables) {
  return {
    updateMap: {
      ...variables
    },
  };
}

function commit(
  variables: UpdateMapMutationVariables
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
          onCompleted: (response: UpdateMapMutationResponse) => {
            resolve(response.updateMap as MutationResult);
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
