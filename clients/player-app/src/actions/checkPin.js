import client from '../apollo';
import gql from 'graphql-tag';

const mutation = gql`
  mutation checkPin($input: CheckPinInput!) {
    checkPin(input: $input) {
      success
    }
  }
`;

function checkPin(pin) {
  return client
    .mutate({ mutation: mutation, variables: { input: { pin } } })
    .then(response => response.data.checkPin.success)
    .catch(error => console.log(error));
}

export { checkPin };
