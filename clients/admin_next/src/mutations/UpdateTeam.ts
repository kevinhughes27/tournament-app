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
  success: (mutation: UpdateTeamMutation) => void,
  failure: (error: Error | undefined) => void
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
        success(response);
      },
      onError: (error) => {
        failure(error);
      }
    },
  );
}

export default { commit };
