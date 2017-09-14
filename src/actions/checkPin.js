import ApolloClient from 'apollo-client';
import gql from 'graphql-tag';

const client = new ApolloClient();

const mutation = gql`
  mutation checkPin($input: CheckPinInput!) {
    checkPin(input: $input) {
      valid
    }
  }
`;

function checkPin(pin) {
  return client
    .mutate({ mutation: mutation, variables: { input: { pin } } })
    .then(response => response.data.checkPin.valid)
    .catch(error => console.log(error));
}

export { checkPin };
