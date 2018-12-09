import * as React from "react";
import { query } from "../../queries/UserQuery";
import renderQuery from "../../helpers/renderQuery";
import UserShow from "./UserShow";

class User extends React.Component {
  render() {
    return renderQuery(query, {}, UserShow);
  }
}

export default User;
