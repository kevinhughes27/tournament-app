import client from "../modules/apollo";
import { query } from "../views/Schedule";
import gql from "graphql-tag";


const mutation = gql`
  mutation ScheduleGameMutation($input: ScheduleGameInput!) {
    scheduleGame(input:$input) {
      game {
        id
        startTime
        endTime
        field {
          id
          name
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

function commit(variables: ScheduleGameMutationVariables) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
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
      }).then(({ data: { scheduleGame } }) => {
        resolve(scheduleGame as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
