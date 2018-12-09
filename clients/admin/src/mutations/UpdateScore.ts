import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
import { query } from "../views/Games/GameListContainer";
import gql from "graphql-tag";

const mutation = gql`
  mutation UpdateScoreMutation($input: UpdateScoreInput!) {
    updateScore(input:$input) {
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

function commit(variables: UpdateScoreMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update: (store) => {
        const data = store.readQuery({ query }) as any;
        const gameIdx = data.games.findIndex((g: GameListQuery_games) => {
          return g.id === variables.input.gameId
        });

        data.games[gameIdx].homeScore = variables.input.homeScore;
        data.games[gameIdx].awayScore = variables.input.awayScore;

        store.writeQuery({ query, data });
      }
    }).then(({ data: { updateScore } }) => {
      resolve(updateScore as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
