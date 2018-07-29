import { commitMutation, graphql } from "react-relay";
import environment from "../relay";

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

function getOptimisticResponse(variables: UnscheduleGameMutationVariables) {
  return {
    unscheduleGame: {
      game: {
        id: variables.gameId,
        startTime: null,
        endTime: null,
        field: null
      }
    },
  };
}

function commit(
  variables: UnscheduleGameMutationVariables,
  success: (result: SchedulingResult) => void,
  failure: (error: Error | undefined) => void
) {
  return commitMutation(
    environment,
    {
      mutation,
      variables,
      optimisticResponse: getOptimisticResponse(variables),
      onCompleted: (response) => {
        success(response.unscheduleGame as SchedulingResult);
      },
      onError: (error) => {
        failure(error);
      }
    },
  );
}

export default { commit };
