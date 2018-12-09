import client from "../modules/apollo";
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
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
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
    }
  );
}

export default { commit };
