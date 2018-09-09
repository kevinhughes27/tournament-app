import { commitMutation, graphql } from "react-relay";
import environment from "../helpers/relay";

const mutation = graphql`
  mutation UnscheduleGameMutation($input: UnscheduleGameInput!) {
    unscheduleGame(input:$input) {
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

function getOptimisticResponse(variables: UnscheduleGameMutationVariables) {
  return {
    unscheduleGame: {
      game: {
        id: variables.input.gameId,
        startTime: null,
        endTime: null,
        field: null
      }
    },
  };
}

function commit(
  variables: UnscheduleGameMutationVariables,
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
          onCompleted: (response: UnscheduleGameMutationResponse) => {
            resolve(response.unscheduleGame as MutationResult);
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
