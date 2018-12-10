import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import mutationUpdater from '../helpers/mutationUpdater';
import { query } from '../queries/TeamShowQuery';
import gql from 'graphql-tag';

const mutation = gql`
  mutation UpdateTeamMutation($input: UpdateTeamInput!) {
    updateTeam(input: $input) {
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
      confirm
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

const update = mutationUpdater<UpdateTeamMutation>((store, payload) => {
  const data = safeReadQuery(store, query);

  if (data && payload.updateTeam && payload.updateTeam.success) {
    const updatedTeam = payload.updateTeam.team;

    const teamIdx = data.teams.findIndex((t: any) => {
      return t.id === updatedTeam.id;
    });

    Object.assign(data.teams[teamIdx], updatedTeam);

    store.writeQuery({ query, data });
  }
});

function commit(variables: UpdateTeamMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { updateTeam } }) => {
        resolve(updateTeam as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
