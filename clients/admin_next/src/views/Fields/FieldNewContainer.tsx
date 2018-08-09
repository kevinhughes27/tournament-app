import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import FieldNew from "./FieldNew";

class FieldNewContainer extends React.Component {
  render() {
    const query = graphql`
      query FieldNewContainerQuery {
        map {
        ...FieldNew_map
        }
        fields {
          ...FieldNew_fields
        }
      }
    `;

    return renderQuery(query, {}, FieldNew);
  }
}

export default FieldNewContainer;
