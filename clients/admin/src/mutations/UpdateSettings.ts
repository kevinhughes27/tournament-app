import client from '../modules/apollo';
import mutationPromise from '../helpers/mutationPromise';
import mutationUpdater from '../helpers/mutationUpdater';
import { query } from '../queries/SettingsQuery';
import gql from 'graphql-tag';

const mutation = gql`
  mutation UpdateSettingsMutation($input: UpdateSettingsInput!) {
    updateSettings(input: $input) {
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

const update = mutationUpdater<UpdateSettingsMutation>((store, payload) => {
  if (payload.updateSettings && payload.updateSettings.success) {
    const data = store.readQuery({ query }) as any;
    const updatedSettings = payload.updateSettings.settings;

    data.settings = updatedSettings;
    store.writeQuery({ query, data });
  }
});

function commit(variables: UpdateSettingsMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client
      .mutate({
        mutation,
        variables,
        update
      })
      .then(({ data: { updateSettings } }) => {
        resolve(updateSettings as MutationResult);
      })
      .catch(error => {
        reject(error);
      });
  });
}

export default { commit };
