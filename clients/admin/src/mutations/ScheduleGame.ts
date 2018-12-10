import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise";
import mutationUpdater from "../helpers/mutationUpdater";
import { query } from "../queries/ScheduleEditorQuery";
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

const update = mutationUpdater<ScheduleGameMutation>((store, payload) => {
  if (payload.scheduleGame) {
    const data = store.readQuery({ query }) as any;
    const scheduledGame = payload.scheduleGame.game;

    const gameIdx = data.games.findIndex((g: any) => {
      return g.id === scheduledGame.id;
    });

    Object.assign(data.games[gameIdx], scheduledGame);

    store.writeQuery({ query, data });
  }
});

function commit(variables: ScheduleGameMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update
    }).then(({ data: { scheduleGame } }) => {
      resolve(scheduleGame as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
