import client from "../modules/apollo";
import gql from "graphql-tag";

const mutation = gql`
  mutation DeleteDivisionMutation($input: DeleteDivisionInput!) {
    deleteDivision(input:$input) {
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

function commit(variables: DeleteDivisionMutationVariables) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      client.mutate({
        mutation,
        variables,
        update: () => {
          client.resetStore();
        }
      }).then(({ data: { deleteDivision } }) => {
        resolve(deleteDivision as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
