import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import gql from 'graphql-tag';

const mutation = gql`
  mutation ChangeUserPasswordMutation($input: ChangeUserPasswordInput!) {
    changeUserPassword(input: $input) {
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
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables
      })
      .then(({ data: { changeUserPassword } }) => {
        resolve(changeUserPassword as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
