import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import Setting from "./Setting";

class  SettingContainer extends React.Component {
  render() {
    const query = graphql`
      query SettingContainerQuery {
        settings {
          ...Setting_settings
        }
      }
    `;

    return renderQuery(query, {}, Setting);
  }
}

export default SettingContainer;
