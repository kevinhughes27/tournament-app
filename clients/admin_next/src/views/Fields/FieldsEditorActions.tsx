import * as React from "react";
import ActionMenu from "../../components/ActionMenu";
import ActionButton from "../../components/ActionButton";
import EditIcon from "@material-ui/icons/Edit";
import AddIcon from "@material-ui/icons/Add";

interface Props {
  mode: "view" | "editMap" | "addField" | "editField";
  editMap: () => void;
  addField: () => void;
  saveMap: () => void;
  createField: () => void;
  saveField: () => void;
}

class FieldsEditorActions extends React.Component<Props> {

  render() {
    const { mode, saveMap, createField, saveField } = this.props;

    if (mode === "view") {
      return this.viewActions();
    } else if (mode === "editMap") {
      return <ActionButton icon="save" onClick={saveMap} />;
    } else if (mode === "addField") {
      return <ActionButton icon="save" onClick={createField} />;
    } else if (mode === "editField") {
      return <ActionButton icon="save" onClick={saveField} />;
    } else {
      return null;
    }
  }

  viewActions = () => {
    const { editMap, addField } = this.props;

    const actions = [
      {icon: <EditIcon/>, name: "Edit Map", handler: editMap },
      {icon: <AddIcon/>, name: "Add Field", handler: addField },
    ];

    return <ActionMenu actions={actions}/>;
  }
}

export default FieldsEditorActions;
