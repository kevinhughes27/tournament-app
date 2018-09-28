import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import Settings from "./Settings";

class  SettingsContainer extends React.Component {
  render() {
    const query = graphql`
      query SettingsContainerQuery {
        settings {
          ...Settings_settings
        }
      }
    `;

    return renderQuery(query, {}, Settings);
  }
}

export default SettingsContainer;
