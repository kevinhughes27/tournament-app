import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import FieldsEditor from "./FieldsEditor";

export const query = gql`
  query FieldsEditorQuery {
    map {
      lat
      long
      zoom
    }
    fields {
      id
      name
      lat
      long
      geoJson
    }
  }
`;

class FieldsEditorContainer extends React.Component {
  render() {
    return renderQuery(query, {}, FieldsEditor);
  }
}

export default FieldsEditorContainer;
