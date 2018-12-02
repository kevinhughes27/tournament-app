import { commitMutation, graphql } from "react-relay";
import environment from "../modules/relay";

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

function getOptimisticResponse(variables: UpdateTeamMutationVariables) {
  return {
    updateTeam: {
      team: {
        ...variables
      }
    },
  };
}

function commit(
  variables: UpdateTeamMutationVariables,
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
          onCompleted: (response: UpdateTeamMutationResponse) => {
            resolve(response.updateTeam as MutationResult);
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
