import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
import { query as SettingsQuery } from "../views/Settings";
import gql from "graphql-tag";

const mutation = gql`
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

function commit(variables: UpdateSettingsMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      refetchQueries:[{ query: SettingsQuery }]
    }).then(({ data: { updateSettings } }) => {
      resolve(updateSettings as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
