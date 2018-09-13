import { commitMutation, graphql } from "react-relay";
import environment from "../helpers/relay";

const mutation = graphql`
  mutation UpdateUserMutation($input: UpdateUserInput!) {
    updateUser(input:$input) {
      user {
        id
        name
        email
      }
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

function getOptimisticResponse(variables: UpdateUserMutationVariables) {
  return {
    updateUser: {
      user: {
        ...variables
      }
    },
  };
}

function commit(
  variables: UpdateUserMutationVariables,
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
          optimisticResponse: getOptimisticResponse(variables),
          onCompleted: (response: UpdateUserMutationResponse) => {
            resolve(response.updateUser as MutationResult);
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
