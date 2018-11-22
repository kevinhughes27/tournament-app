import { commitMutation, graphql } from "react-relay";
import environment from "../modules/relay";

const mutation = graphql`
  mutation DeleteTeamMutation($input: DeleteTeamInput!) {
    deleteTeam(input:$input) {
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

function commit(
  variables: DeleteTeamMutationVariables,
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
          onCompleted: (response: DeleteTeamMutationResponse) => {
            resolve(response.deleteTeam as MutationResult);
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
