import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import mutationUpdater from '../helpers/mutationUpdater';
import { query } from '../queries/DivisionSeedQuery';
import gql from 'graphql-tag';

const mutation = gql`
  mutation CreateSeedMutation($input: CreateSeedInput!) {
    createSeed(input: $input) {
      division {
        teams {
          id
          name
          division {
            id
            name
          }
          seed
        }
      }
      success
      message
    }
  }
`;

const safeReadQuery = (store: any, query: any, variables: any) => {
  try {
    return store.readQuery({ query, variables });
  } catch {
    return null;
  }
};

function commit(variables: CreateSeedMutationVariables) {
  const update = mutationUpdater<CreateSeedMutation>((store, payload) => {
    const { teamId, divisionId, rank } = variables.input;
    const data = safeReadQuery(store, query, { divisionId });

    if (data && payload.createSeed && payload.createSeed.success) {
      data.division.teams = payload.createSeed.division.teams;

      const teamIdx = data.teams.findIndex((t: any) => t.id === teamId);
      Object.assign(data.teams[teamIdx], { seed: rank });

      store.writeQuery({ query, data });
    }
  });

  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { createSeed } }) => {
        resolve(createSeed as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
