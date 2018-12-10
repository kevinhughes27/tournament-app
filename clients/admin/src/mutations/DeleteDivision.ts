import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import gql from 'graphql-tag';

const mutation = gql`
  mutation DeleteDivisionMutation($input: DeleteDivisionInput!) {
    deleteDivision(input: $input) {
      division {
        id
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

const update = () => {
  client.resetStore();
};

function commit(variables: DeleteDivisionMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { deleteDivision } }) => {
        resolve(deleteDivision as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
