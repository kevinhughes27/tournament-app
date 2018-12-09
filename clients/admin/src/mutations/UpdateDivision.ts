import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
import gql from "graphql-tag";

const mutation = gql`
  mutation UpdateDivisionMutation($input: UpdateDivisionInput!) {
    updateDivision(input:$input) {
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
      confirm
      message
      userErrors {
        field
        message
      }
    }
  }
`;

function commit(variables: UpdateDivisionMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update: () => {
        client.resetStore();
      }
    }).then(({ data: { updateDivision } }) => {
      resolve(updateDivision as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
