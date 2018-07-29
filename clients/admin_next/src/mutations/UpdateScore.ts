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

function getOptimisticResponse(variables: UpdateScoreMutationVariables) {
  return {
    updateScore: {
      game: {
        ...variables
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
  variables: UpdateScoreMutationVariables
) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      commitMutation(
        environment,
        {
          mutation,
          variables,
          optimisticResponse: getOptimisticResponse(variables),
          updater: blindTrustUpdater,
          onCompleted: (response: UpdateScoreMutationResponse) => {
            resolve(response.updateScore as MutationResult);
          },
          onError: (error) => {
            reject(error);
          }
        },
      );
    }
  );
}

export default { commit };
