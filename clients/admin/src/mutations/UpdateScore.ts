import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import mutationUpdater from '../helpers/mutationUpdater';
import { query } from '../queries/GamesListQuery';
import gql from 'graphql-tag';

const mutation = gql`
  mutation UpdateScoreMutation($input: UpdateScoreInput!) {
    updateScore(input: $input) {
      game {
        id
        homeScore
        awayScore
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

const update = mutationUpdater<UpdateScoreMutation>((store, payload) => {
  if (payload.updateScore && payload.updateScore.success) {
    const data = store.readQuery({ query }) as any;
    const updatedGame = payload.updateScore.game;

    const gameIdx = data.games.findIndex((g: any) => {
      return g.id === updatedGame.id;
    });

    Object.assign(data.games[gameIdx], updatedGame);

    store.writeQuery({ query, data });
  }
});

function commit(variables: UpdateScoreMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { updateScore } }) => {
        resolve(updateScore as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
