import { commitMutation, graphql } from "react-relay";
import { Environment, PayloadError } from "relay-runtime";

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
      userErrors
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
  callback: (mutation: UpdateTeam, errors: PayloadError[] | null | undefined) => void
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
      onCompleted: (response, errors) => {
        callback(response, errors);
      },
    },
  );
}

export default { commit };
