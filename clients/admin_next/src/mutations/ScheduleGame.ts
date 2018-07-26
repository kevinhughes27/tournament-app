import { commitMutation, graphql } from "react-relay";
import environment from "../relay";

const mutation = graphql`
  mutation ScheduleGameMutation($input: ScheduleGameInput!) {
    scheduleGame(input:$input) {
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

function getOptimisticResponse(input: any, game: Game) {
  return {
    scheduleGame: {
      game: {
        id: game.id,
        startTime: input.startTime,
        endTime: input.endTime,
        field: {
          id: input.fieldId
        }
      }
    },
  };
}

function commit(
  input: any,
  game: Game,
  success: (result: ScheduleGame) => void,
  failure: (error: Error | undefined) => void
) {
  return commitMutation(
    environment,
    {
      mutation,
      optimisticResponse: getOptimisticResponse(input, game),
      variables: {
        input: {
          gameId: game.id,
          ...input
        },
      },
      onCompleted: (response) => {
        success(response.scheduleGame);
      },
      onError: (error) => {
        failure(error);
      }
    },
  );
}

export default { commit }
