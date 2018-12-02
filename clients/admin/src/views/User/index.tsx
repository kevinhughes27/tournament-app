import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderQuery";
import UserShow from "./UserShow";

class User extends React.Component {
  render() {
    const query = graphql`
      query UserQuery {
        viewer {
          ...UserShow_viewer
        }
      }
    `;

    return renderQuery(query, {}, UserShow);
  }
}

export default User;
