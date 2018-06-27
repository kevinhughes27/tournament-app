import * as React from "react";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

import FieldMap from "./FieldMap";

const query = graphql`
  query FieldMapContainerQuery {
    map {
     ...FieldMap_map
    }
    fields {
      ...FieldMap_fields
    }
  }
`;

class FieldMapContainer extends React.Component {
  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{}}
        render={render(FieldMap)}
      />
    );
  }
}

export default FieldMapContainer;
