import { commitMutation, graphql } from "react-relay";
import environment from "../relay";

const mutation = graphql`
  mutation UpdateTeamMutation($input: UpdateTeamInput!) {
    updateTeam(input:$input) {
      team {
        id
        name
        email
        divisionId
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

function getOptimisticResponse(input: any, team: Team) {
  return {
    updateTeam: {
      team: {
        id: team.id,
        ...input
      }
    },
  };
}

function commit(
  input: any,
  team: Team
) {
  return new Promise((resolve: (result: UpdateTeam) => void, reject: (error: Error | undefined) => void) => {
    return commitMutation(
      environment,
      {
        mutation,
        optimisticResponse: getOptimisticResponse(input, team),
        variables: {
          input: {
            teamId: team.id,
            ...input
          },
        },
        onCompleted: (response) => {
          resolve(response.updateTeam);
        },
        onError: (error) => {
          reject(error);
        }
      },
    );
  });
}

export default { commit }
