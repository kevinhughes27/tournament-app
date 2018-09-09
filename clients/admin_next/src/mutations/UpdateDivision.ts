import { commitMutation, graphql } from "react-relay";
import environment from "../helpers/relay";

const mutation = graphql`
  mutation UpdateDivisionMutation($input: UpdateDivisionInput!) {
    updateDivision(input:$input) {
      division {
        id
        name
        numTeams
        numDays
        bracket {
          handle
        }
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

function getOptimisticResponse(variables: UpdateDivisionMutationVariables) {
  return {
    updateDivision: {
      division: {
        ...variables
      }
    },
  };
}

function commit(
  variables: UpdateDivisionMutationVariables
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
          onCompleted: (response: UpdateDivisionMutationResponse) => {
            resolve(response.updateDivision as MutationResult);
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
