import gql from "graphql-tag";

export const query = gql`
  query SettingsQuery {
    settings {
      name
      handle
      timezone
      scoreSubmitPin
      gameConfirmSetting
    }
  }
`;
