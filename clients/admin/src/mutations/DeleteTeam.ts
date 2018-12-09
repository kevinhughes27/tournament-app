import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
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
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      refetchQueries: [{ query: TeamListContainer }],
    }).then(({ data: { deleteTeam } }) => {
      resolve(deleteTeam as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
