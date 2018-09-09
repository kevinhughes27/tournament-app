import { commitMutation, graphql } from "react-relay";
import environment from "../helpers/relay";

const mutation = graphql`
  mutation CreateDivisionMutation($input: CreateDivisionInput!) {
    createDivision(input:$input) {
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
      message
      userErrors {
        field
        message
      }
    }
  }
`;

function getOptimisticResponse(variables: CreateDivisionMutationVariables) {
  return {
    createDivision: {
      division: {
        ...variables
      }
    },
  };
}

function commit(
  variables: CreateDivisionMutationVariables
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
          onCompleted: (response: CreateDivisionMutationResponse) => {
            resolve(response.createDivision as MutationResult);
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
