import * as React from "react";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

import DivisionList from "./DivisionList";

const query = graphql`
  query DivisionListContainerQuery {
    divisions {
      ...DivisionList_divisions
    }
  }
`;

class DivisionListContainer extends React.Component {
  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{}}
        render={render(DivisionList)}
      />
    );
  }
}

export default DivisionListContainer;
