import { commitMutation, graphql } from "react-relay";
import environment from "../helpers/relay";

const mutation = graphql`
  mutation ChangeUserPasswordMutation($input: ChangeUserPasswordInput!) {
    changeUserPassword(input:$input) {
      success
      message
      userErrors {
        field
        message
      }
    }
  }
`;

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
          onCompleted: (response: ChangeUserPasswordMutationResponse) => {
            resolve(response.changeUserPassword as MutationResult);
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
