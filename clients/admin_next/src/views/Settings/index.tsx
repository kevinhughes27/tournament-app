import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import SettingsEdit from "./SettingsEdit";

const query = graphql`
  query SettingsQuery {
    settings {
      ...SettingsEdit_settings
    }
  }
`;

class Settings extends React.Component {
  render() {
    return renderQuery(query, {}, SettingsEdit);
  }
}

export default Settings;
