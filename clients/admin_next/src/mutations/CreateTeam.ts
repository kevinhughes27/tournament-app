import { commitMutation, graphql } from "react-relay";
import environment from "../relay";

const mutation = graphql`
  mutation CreateTeamMutation($input: CreateTeamInput!) {
    createTeam(input:$input) {
      team {
        id
        name
        email
        divisionId
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

function getOptimisticResponse(input: any) {
  return {
    createTeam: {
      team: {
        id: "new",
        ...input
      }
    },
  };
}

function commit(
  input: any
) {
  return new Promise((resolve: (result: UpdateTeam) => void, reject: (error: Error | undefined) => void) => {
    return commitMutation(
      environment,
      {
        mutation,
        optimisticResponse: getOptimisticResponse(input),
        variables: { input },
        onCompleted: (response) => {
          resolve(response.createTeam);
        },
        onError: (error) => {
          reject(error);
        }
      },
    );
  });
}

export default { commit };
