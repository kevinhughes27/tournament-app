import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import UserShow from "./UserShow";

const query = gql`
  query UserQuery {
    viewer {
      name
      email
    }
  }
`;

class User extends React.Component {
  render() {
    return renderQuery(query, {}, UserShow);
  }
}

export default User;
