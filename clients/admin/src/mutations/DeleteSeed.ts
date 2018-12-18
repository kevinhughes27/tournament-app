import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import mutationUpdater from '../helpers/mutationUpdater';
import { query } from '../queries/DivisionSeedQuery';
import gql from 'graphql-tag';

const mutation = gql`
  mutation DeleteSeedMutation($input: DeleteSeedInput!) {
    deleteSeed(input: $input) {
      success
      confirm
      message
    }
  }
`;

function commit(variables: DeleteSeedMutationVariables) {
  const update = mutationUpdater<DeleteSeedMutation>((store, payload) => {
    const { teamId, divisionId } = variables.input;
    const data = store.readQuery({ query, variables: { divisionId } }) as any;

    if (data && payload.deleteSeed && payload.deleteSeed.success) {
      const teamIdx = data.teams.findIndex((t: any) => t.id === teamId);
      Object.assign(data.teams[teamIdx], { seed: null });

      const dTeamIdx = data.division.teams.findIndex(
        (t: any) => t.id === teamId
      );
      Object.assign(data.division.teams[dTeamIdx], { seed: null });

      store.writeQuery({ query, data });
    }
  });

  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { deleteSeed } }) => {
        resolve(deleteSeed as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
