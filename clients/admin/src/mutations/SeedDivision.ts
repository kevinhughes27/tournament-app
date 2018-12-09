import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
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
  return mutationPromise((resolve, reject) => {
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
  });
}

export default { commit };
