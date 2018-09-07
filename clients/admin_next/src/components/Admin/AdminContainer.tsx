import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Admin from "./Admin";

const query = graphql`
  query AdminContainerQuery {
    viewer {
      ...Admin_viewer
    }
  }
`;

const loader = () => (
  <AppBar position="static">
    <Toolbar />
  </AppBar>
);

class AdminContainer extends React.Component {
 render() {
    return renderQuery(query, {}, Admin, {loader});
  }
}

export default AdminContainer;
