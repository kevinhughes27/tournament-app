import * as React from "react";
import { query } from "../../queries/UserMenuQuery";
import renderQuery from "../../helpers/renderQuery";
import UserMenu from "./UserMenu";

const loader = () => (<span/>);

class UserMenuContainer extends React.Component {
  render() {
    return renderQuery(query, {}, UserMenu, {loader});
  }
}

export default UserMenuContainer;
