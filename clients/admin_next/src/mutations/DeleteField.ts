import { commitMutation, graphql } from "react-relay";
import environment from "../relay";

const mutation = graphql`
  mutation DeleteFieldMutation($input: DeleteFieldInput!) {
    deleteField(input:$input) {
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
  variables: DeleteFieldMutationVariables,
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
          onCompleted: (response: DeleteFieldMutationResponse) => {
            resolve(response.deleteField as MutationResult);
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
