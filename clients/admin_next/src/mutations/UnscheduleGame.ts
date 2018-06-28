import { commitMutation, graphql } from "react-relay";
import { Environment } from "relay-runtime";

const mutation = graphql`
  mutation UnscheduleGameMutation($gameId: ID!) {
    unscheduleGame(gameId:$gameId) {
      game {
        id
        startTime
        endTime
        field {
          id
        }
      }
      success
      message
    }
  }
`;

function getOptimisticResponse(game: Game) {
  return {
    unscheduleGame: {
      game: {
        id: game.id,
        startTime: null,
        endTime: null,
        field: null
      }
    },
  };
}

function commit(
  environment: Environment,
  game: Game,
  success: (result: UnscheduleGame) => void,
  failure: (error: Error | undefined) => void
) {
  return commitMutation(
    environment,
    {
      mutation,
      optimisticResponse: getOptimisticResponse(game),
      variables: {
        gameId: game.id
      },
      onCompleted: (response) => {
        success(response.unscheduleGame);
      },
      onError: (error) => {
        failure(error);
      }
    },
  );
}

export default { commit };
