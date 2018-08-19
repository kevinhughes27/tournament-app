import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import FieldsEditor from "./FieldsEditor";

const query = graphql`
  query FieldsEditorContainerQuery {
    map {
     ...FieldsEditor_map
    }
    fields {
      ...FieldsEditor_fields
    }
  }
`;

class FieldsEditorContainer extends React.Component {
  render() {
    return renderQuery(query, {}, FieldsEditor);
  }
}

export default FieldsEditorContainer;
