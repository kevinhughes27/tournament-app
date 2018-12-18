import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import mutationUpdater from '../helpers/mutationUpdater';
import { query } from '../queries/FieldsEditorQuery';
import gql from 'graphql-tag';

const mutation = gql`
  mutation UpdateMapMutation($input: UpdateMapInput!) {
    updateMap(input: $input) {
      success
      message
    }
  }
`;

function commit(variables: UpdateMapMutationVariables) {
  const update = mutationUpdater<DeleteSeedMutation>(store => {
    const data = store.readQuery({ query }) as any;
    Object.assign(data.map, { ...variables.input });
    store.writeQuery({ query, data });
  });

  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { updateMap } }) => {
        resolve(updateMap as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
