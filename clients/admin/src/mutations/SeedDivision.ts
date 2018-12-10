import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import gql from 'graphql-tag';

const mutation = gql`
  mutation SeedDivisionMutation($input: SeedDivisionInput!) {
    seedDivision(input: $input) {
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

const update = () => {
  client.resetStore();
};

function commit(variables: SeedDivisionMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { seedDivision } }) => {
        resolve(seedDivision as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
