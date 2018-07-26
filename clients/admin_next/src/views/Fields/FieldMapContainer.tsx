import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
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
    return renderQuery(query, {}, FieldMap);
  }
}

export default FieldMapContainer;
