import * as React from "react";
import { query } from "../../queries/FieldsEditorQuery";
import renderQuery from "../../helpers/renderQuery";
import FieldsEditor from "./FieldsEditor";

class FieldsEditorContainer extends React.Component {
  render() {
    return renderQuery(query, {}, FieldsEditor);
  }
}

export default FieldsEditorContainer;
