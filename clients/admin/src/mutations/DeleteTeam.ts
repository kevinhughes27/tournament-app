import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise";
import { query as TeamListQuery } from "../queries/TeamListQuery";
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
      refetchQueries: [{ query: TeamListQuery }],
    }).then(({ data: { deleteTeam } }) => {
      resolve(deleteTeam as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
