import { commitMutation, graphql } from "react-relay";
import environment from "../helpers/relay";

const mutation = graphql`
  mutation ChangeUserPasswordMutation($input: UpdateUserInput!) {
    updateUser(input:$input) {
      user {
        id
        name
        email
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

function getOptimisticResponse(variables: ChangeUserPasswordMutationVariables) {
  return {
    updateUser: {
      user: {
        ...variables
      }
    },
  };
}

function commit(
  variables: ChangeUserPasswordMutationVariables,
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
          onCompleted: (response: ChangeUserPasswordMutationResponse) => {
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
