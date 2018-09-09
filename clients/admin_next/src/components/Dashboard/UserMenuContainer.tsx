import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import UserMenu from "./UserMenu";

const query = graphql`
  query UserMenuContainerQuery {
    viewer {
      ...UserMenu_viewer
    }
  }
`;

const loader = () => (<span/>);

class UserMenuContainer extends React.Component {
  render() {
    return renderQuery(query, {}, UserMenu, {loader});
  }
}

export default UserMenuContainer;
