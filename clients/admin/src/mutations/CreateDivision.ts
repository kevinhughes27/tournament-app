import client from "../modules/apollo";
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
      }).then(({ data: { createDivision } }) => {
        resolve(createDivision as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
