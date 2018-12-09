import client from "../modules/apollo";
import gql from "graphql-tag";

const mutation = gql`
  mutation SeedDivisionMutation($input: SeedDivisionInput!) {
    seedDivision(input:$input) {
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

function commit(variables: SeedDivisionMutationVariables) {
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
      }).then(({ data: { seedDivision } }) => {
        resolve(seedDivision as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
