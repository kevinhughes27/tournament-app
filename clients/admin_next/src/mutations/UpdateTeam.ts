import { commitMutation, graphql } from "react-relay";
import { Environment } from "relay-runtime";

const mutation = graphql`
  mutation UpdateTeamMutation($input: UpdateTeamInput!) {
    updateTeam(input:$input) {
      team {
        id
        name
        seed
      }
      success
      confirm
      userErrors
    }
  }
`;

function getOptimisticResponse(name: string, seed: number, team: Team) {
  return {
    updateTeam: {
      team: {
        id: team.id,
        name: name,
        seed: seed
      }
    },
  };
}

interface Team {
  id: number;
  name: string;
  seed: number;
}

function commit(
  environment: Environment,
  name: string,
  seed: number,
  team: Team,
  callback: Function
) {
  return commitMutation(
    environment,
    {
      mutation,
      optimisticResponse: getOptimisticResponse(name, seed, team),
      variables: {
        input: {
          teamId: team.id,
          name: name,
          seed: seed
        },
      },
      onCompleted: (response, errors) => {
        callback(response.updateTeam, errors);
      },
    },
  );
}

export default { commit };
