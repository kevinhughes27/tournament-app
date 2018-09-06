import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import Admin from "./Admin";

const query = graphql`
  query AdminContainerQuery {
    viewer {
      ...UserMenu_viewer
    }
  }
`;

class AdminContainer extends React.Component {
 render() {
    return renderQuery(query, {}, Admin);
  }
}

export default AdminContainer;
