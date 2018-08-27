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

function getOptimisticResponse(variables: ScheduleGameMutationVariables) {
  return {
    scheduleGame: {
      game: {
        ...variables.input
      }
    },
  };
}

function commit(
  variables: ScheduleGameMutationVariables,
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
        success(response.scheduleGame as SchedulingResult);
      },
      onError: (error) => {
        failure(error);
      }
    },
  );
}

export default { commit };
