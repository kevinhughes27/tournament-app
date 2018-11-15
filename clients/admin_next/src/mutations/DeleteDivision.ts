import { commitMutation, graphql } from "react-relay";
import environment from "../modules/relay";

const mutation = graphql`
  mutation DeleteDivisionMutation($input: DeleteDivisionInput!) {
    deleteDivision(input:$input) {
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
  variables: DeleteDivisionMutationVariables,
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
          onCompleted: (response: DeleteDivisionMutationResponse) => {
            resolve(response.deleteDivision as MutationResult);
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
