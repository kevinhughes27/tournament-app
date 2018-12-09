import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise";
import gql from "graphql-tag";

const mutation = gql`
  mutation CreateDivisionMutation($input: CreateDivisionInput!) {
    createDivision(input:$input) {
      division {
        id
        name
        numTeams
        numDays
        bracket {
          handle
        }
      }
      success
      message
      userErrors {
        field
        message
      }
    }
  }
`;

function commit(variables: CreateDivisionMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update: () => {
        client.resetStore();
      }
    }).then(({ data: { createDivision } }) => {
      resolve(createDivision as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
