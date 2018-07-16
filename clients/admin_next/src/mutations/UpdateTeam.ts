import { commitMutation, graphql } from "react-relay";
import { Environment } from "relay-runtime";

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
  environment: Environment,
  input: any,
  team: Team,
  success: (result: UpdateTeam) => void,
  failure: (error: string) => void
) {
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
        success(response.updateTeam);
      },
      onError: (error) => {
        failure(error && error.message || "Something went wrong.");
      }
    },
  );
}

export default { commit };
