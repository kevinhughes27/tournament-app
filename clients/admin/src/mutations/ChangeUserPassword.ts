import client from "../modules/apollo";
import gql from "graphql-tag";

const mutation = gql`
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

function commit(variables: ChangeUserPasswordMutationVariables) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      client.mutate({
        mutation,
        variables
      }).then(({ data: { changeUserPassword } }) => {
        resolve(changeUserPassword as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
