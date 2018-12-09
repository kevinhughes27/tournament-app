import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
import { query } from "../views/Schedule";
import gql from "graphql-tag";

const mutation = gql`
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

function commit(variables: UnscheduleGameMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update: (store, { data: { scheduleGame } }) => {
        const data = store.readQuery({ query }) as any;
        const gameIdx = data.games.findIndex((g: any) => {
          return g.id === variables.input.gameId;
        });

        Object.assign(data.games[gameIdx], scheduleGame.game);

        store.writeQuery({ query, data });
      }
    }).then(({ data: { unscheduleGame } }) => {
      resolve(unscheduleGame as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
