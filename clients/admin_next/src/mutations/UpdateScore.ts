import { commitMutation, graphql } from "react-relay";
import { Environment, RecordSourceSelectorProxy } from "relay-runtime";

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
  environment: Environment,
  input: any,
  game: Game,
  success: (result: UpdateScore) => void,
  failure: (error: Error | undefined) => void
) {
  return commitMutation(
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
        success(response.updateScore);
      },
      onError: (error) => {
        failure(error);
      }
    },
  );
}

export default { commit };
