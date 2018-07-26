import { commitMutation, graphql } from "react-relay";
import { RecordSourceSelectorProxy } from "relay-runtime";
import environment from "../relay";

const mutation = graphql`
  mutation UpdateScoreMutation($input: UpdateScoreInput!) {
    updateScore(input:$input) {
      success
      message
    }
  }
`;

function getOptimisticResponse(input: any, game: Game) {
  return {
    updateScore: {
      game: {
        id: game.id,
        ...input
      }
    },
  };
}

function blindTrustUpdater(store: RecordSourceSelectorProxy) {
  const updateScore = store.getRootField("updateScore");
  if (updateScore) {
    const input = JSON.parse(
      updateScore.getDataID()
        .replace("client:root:updateScore(input:", "")
        .replace(")", "")
    );

    const game = store.get(input.gameId);

    if (game) {
      game.setValue(input.homeScore, "homeScore");
      game.setValue(input.awayScore, "awayScore");
    }
  }
}

function commit(
  input: any,
  game: Game
) {
  return new Promise((resolve: (result: UpdateTeam) => void, reject: (error: Error | undefined) => void) => {
    commitMutation(
      environment,
      {
        mutation,
        optimisticResponse: getOptimisticResponse(input, game),
        updater: blindTrustUpdater,
        variables: {
          input: {
            gameId: game.id,
            ...input
          },
        },
      onCompleted: (response) => {
        resolve(response.updateScore);
      },
      onError: (error) => {
        reject(error);
      }
      },
    );
  });
}

export default { commit }
