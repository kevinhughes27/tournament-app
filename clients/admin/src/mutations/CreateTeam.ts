import { commitMutation, graphql } from "react-relay";
import { RecordSourceSelectorProxy } from "relay-runtime";
import environment from "../modules/relay";

const mutation = graphql`
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

function getOptimisticResponse(variables: CreateTeamMutationVariables) {
  return {
    createTeam: {
      team: {
        ...variables
      }
    },
  };
}

function updater(store: RecordSourceSelectorProxy) {
  const root = store.getRoot();
  const payload = store.getRootField("createTeam");

  if (root && payload) {
    const teams = root.getLinkedRecords("teams") || [];
    const newTeam = payload.getLinkedRecord("team");
    const newTeams = [...teams, newTeam];

    root.setLinkedRecords(newTeams, "teams");
  }
}

function commit(
  variables: CreateTeamMutationVariables
) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      return commitMutation(
        environment,
        {
          mutation,
          variables,
          optimisticResponse: getOptimisticResponse(variables),
          updater,
          onCompleted: (response: CreateTeamMutationResponse) => {
            resolve(response.createTeam as MutationResult);
          },
          onError: (error) => {
            reject(error);
          }
        },
      );
    }
  );
}

export default { commit };
