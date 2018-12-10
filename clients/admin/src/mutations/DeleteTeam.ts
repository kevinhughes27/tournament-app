import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import mutationUpdater from '../helpers/mutationUpdater';
import { query } from '../queries/TeamListQuery';
import gql from 'graphql-tag';

const mutation = gql`
  mutation DeleteTeamMutation($input: DeleteTeamInput!) {
    deleteTeam(input: $input) {
      team {
        id
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

const update = mutationUpdater<DeleteTeamMutation>((store, payload) => {
  if (payload.deleteTeam && payload.deleteTeam.success) {
    const data = store.readQuery({ query }) as any;
    const deletedTeam = payload.deleteTeam.team;

    data.teams = data.teams.filter((t: any) => t.id !== deletedTeam.id);
    store.writeQuery({ query, data });
  }
});

function commit(variables: DeleteTeamMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { deleteTeam } }) => {
        resolve(deleteTeam as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
