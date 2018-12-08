import client from "../modules/apollo";
import { query as TeamListContainer } from "../views/Teams/TeamListContainer";
import gql from "graphql-tag";

const mutation = gql`
  mutation DeleteTeamMutation($input: DeleteTeamInput!) {
    deleteTeam(input:$input) {
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

function commit(variables: DeleteTeamMutationVariables) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      client.mutate({
        mutation,
        variables,
        refetchQueries: [{ query: TeamListContainer }],
      }).then(({ data: { deleteTeam } }) => {
        resolve(deleteTeam as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
