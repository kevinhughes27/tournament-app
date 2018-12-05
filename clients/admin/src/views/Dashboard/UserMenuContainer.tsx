import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import UserMenu from "./UserMenu";

const query = gql`
  query UserMenuQuery {
    viewer {
      id
      name
      email
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
