import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import gql from 'graphql-tag';

const mutation = gql`
  mutation AddUserMutation($input: AddUserInput!) {
    addUser(input: $input) {
      success
      message
      userErrors {
        field
        message
      }
    }
  }
`;

function commit(variables: AddUserMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables
      })
      .then(({ data: { addUser } }) => {
        resolve(addUser as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
