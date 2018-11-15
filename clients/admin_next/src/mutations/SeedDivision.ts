import { commitMutation, graphql } from "react-relay";
import environment from "../modules/relay";

const mutation = graphql`
  mutation SeedDivisionMutation($input: SeedDivisionInput!) {
    seedDivision(input:$input) {
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
  variables: SeedDivisionMutationVariables,
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
          onCompleted: (response: SeedDivisionMutationResponse) => {
            resolve(response.seedDivision as MutationResult);
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
