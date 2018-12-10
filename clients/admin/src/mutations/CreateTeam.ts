import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import mutationUpdater from '../helpers/mutationUpdater';
import { query } from '../queries/TeamListQuery';
import gql from 'graphql-tag';

const mutation = gql`
  mutation CreateTeamMutation($input: CreateTeamInput!) {
    createTeam(input: $input) {
      team {
        id
        name
        email
        division {
          id
          name
        }
        seed
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

const safeReadQuery = (store: any, query: any) => {
  try {
    return store.readQuery({ query });
  } catch {
    return null;
  }
};

const update = mutationUpdater<CreateTeamMutation>((store, payload) => {
  const data = safeReadQuery(store, query);

  if (data && payload.createTeam && payload.createTeam.success) {
    const newTeam = payload.createTeam.team;
    data.teams.push(newTeam);
    store.writeQuery({ query, data });
  }
});

function commit(variables: CreateTeamMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { createTeam } }) => {
        resolve(createTeam as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
