import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import UserEdit from "./UserEdit";

class  UserEditContainer extends React.Component {
  render() {
    const query = graphql`
      query UserEditContainerQuery {
        viewer {
          ...UserEdit_viewer
        }
      }
    `;

    return renderQuery(query, {}, UserEdit);
  }
}

export default UserEditContainer;
