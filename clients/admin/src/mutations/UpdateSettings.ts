import client from "../modules/apollo";
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
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      client.mutate({
        mutation,
        variables,
        refetchQueries:[{ query: SettingsQuery }]
      }).then(({ data: { createDivision } }) => {
        resolve(createDivision as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
