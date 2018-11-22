import { commitMutation, graphql } from "react-relay";
import { RecordSourceSelectorProxy } from "relay-runtime";
import environment from "../modules/relay";

const mutation = graphql`
  mutation UpdateSettingsMutation($input: UpdateSettingsInput!) {
    updateSettings(input:$input) {
      settings {
        name
        handle
        timezone
        scoreSubmitPin
        gameConfirmSetting
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

function getOptimisticResponse(variables: UpdateSettingsMutationVariables) {
  return {
    updateSettings: {
      settings: {
        ...variables
      }
    },
  };
}

function updater(store: RecordSourceSelectorProxy) {
  const root = store.getRoot();
  const payload = store.getRootField("updateSettings");
  const settings = payload!.getLinkedRecord("settings");
  root.setLinkedRecord(settings!, "settings");
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
          updater,
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
