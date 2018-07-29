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

function getOptimisticResponse(variables: CreateTeamMutationVariables) {
  return {
    createTeam: {
      team: {
        ...variables
      }
    },
  };
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
