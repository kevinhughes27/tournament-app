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
      userErrors {
        field
        message
      }
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
) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      return commitMutation(
        environment,
        {
          mutation,
          variables,
          optimisticResponse: getOptimisticResponse(variables),
          onCompleted: (response: ScheduleGameMutationResponse) => {
            resolve(response.scheduleGame as MutationResult);
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
