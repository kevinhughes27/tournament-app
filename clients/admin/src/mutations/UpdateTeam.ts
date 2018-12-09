import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
import { query } from "../views/Teams/TeamShowContainer";
import gql from "graphql-tag";

const mutation = gql`
  mutation UpdateTeamMutation($input: UpdateTeamInput!) {
    updateTeam(input:$input) {
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

function commit(variables: UpdateTeamMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update: (store, { data: { updateTeam } }) => {
        try {
          const data = store.readQuery({ query }) as any;
          data.teams.push(updateTeam.team);
          store.writeQuery({ query, data });
        } catch {}
      }
    }).then(({ data: { updateTeam } }) => {
      resolve(updateTeam as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
