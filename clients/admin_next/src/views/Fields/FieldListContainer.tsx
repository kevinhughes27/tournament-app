import * as React from "react";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

import FieldList from "./FieldList";

const query = graphql`
  query FieldListContainerQuery {
    fields {
      ...FieldList_fields
    }
  }
`;

class FieldListContainer extends React.Component {
  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{}}
        render={render(FieldList)}
      />
    );
  }
}

export default FieldListContainer;
