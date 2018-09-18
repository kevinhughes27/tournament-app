import { commitMutation, graphql } from "react-relay";
import environment from "../helpers/relay";

const mutation = graphql`
  mutation UpdateSettingsMutation($input: UpdateSettingsInput!) {
    updateSettings(input:$input) {
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

function getOptimisticResponse(variables: UpdateSettingsMutationVariables) {
  return {
    updateSettings: {
      settings: {
        ...variables
      }
    },
  };
}

function commit(
  variables: UpdateSettingsMutationVariables,
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
          onCompleted: (response: UpdateSettingsMutationResponse) => {
            resolve(response.updateSettings as MutationResult);
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
