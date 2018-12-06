import client from "../modules/apollo";
import { query } from "../views/Teams/TeamListContainer";
import gql from "graphql-tag";

const mutation = gql`
  mutation CreateTeamMutation($input: CreateTeamInput!) {
    createTeam(input:$input) {
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

function commit(variables: CreateTeamMutationVariables) {
  const optimisticResponse = {
    createTeam: {
      __typename: "CreateTeamPayload",
      team: {
        __typename: "Team",
        id: Math.round(Math.random() * -1000000),
        ...variables.input,
        division: {
          __typename: "Division",
          id: variables.input.divisionId,
          name: ""
        }
      },
      success: true,
      message: "",
      userErrors: []
    }
  };

  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      client.mutate({
        mutation,
        variables,
        optimisticResponse,
        update: (store, { data: { createTeam } }) => {
          try {
            const data = store.readQuery({query}) as any;
            data.teams.push(createTeam.team);
            store.writeQuery({ query, data });
          } catch {}
        }
      }).then(({ data: { createTeam } }) => {
        resolve(createTeam as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
