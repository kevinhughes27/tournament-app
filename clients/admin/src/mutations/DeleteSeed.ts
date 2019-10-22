import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import gql from 'graphql-tag';

const mutation = gql`
  mutation DeleteSeedMutation($input: DeleteSeedInput!) {
    deleteSeed(input: $input) {
      success
      confirm
      message
    }
  }
`;

function commit(variables: DeleteSeedMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        refetchQueries: ["DivisionSeedQuery"],
        awaitRefetchQueries: true
      })
      .then(({ data: { deleteSeed } }) => {
        resolve(deleteSeed as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
