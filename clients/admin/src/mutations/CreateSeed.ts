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
          seed
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

function commit(variables: CreateSeedMutationVariables) {
  const update = mutationUpdater<CreateSeedMutation>((store, payload) => {
    const divisionId = variables.input.divisionId;
    const data = store.readQuery({ query, variables: { divisionId } }) as any;

    if (data && payload.createSeed && payload.createSeed.success) {
      data.division.teams = payload.createSeed.division.teams;
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
