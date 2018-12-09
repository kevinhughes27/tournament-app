import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import SettingsEdit from "./SettingsEdit";

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

class Settings extends React.Component {
  render() {
    return renderQuery(query, {}, SettingsEdit);
  }
}

export default Settings;
