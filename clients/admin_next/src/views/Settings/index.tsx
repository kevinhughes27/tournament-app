import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import SettingsEdit from "./SettingsEdit";

class  Settings extends React.Component {
  render() {
    const query = graphql`
      query SettingsQuery {
        settings {
          ...SettingsEdit_settings
        }
      }
    `;

    return renderQuery(query, {}, SettingsEdit);
  }
}

export default Settings;
