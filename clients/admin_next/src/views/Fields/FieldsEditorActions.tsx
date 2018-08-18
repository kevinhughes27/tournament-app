import * as React from "react";
import ActionMenu from "../../components/ActionMenu";
import SubmitButton from "../../components/SubmitButton";
import EditIcon from "@material-ui/icons/Edit";
import AddIcon from "@material-ui/icons/Add";

interface Props {
  mode: "none" | "view" | "editMap" | "addField" | "editField";
  valid: boolean;
  submitting: boolean;
  editMap: () => void;
  addField: () => void;
  saveMap: () => void;
  createField: () => void;
  saveField: () => void;
}

class FieldsEditorActions extends React.Component<Props> {
  render() {
    const {
      mode,
      valid,
      submitting,
      saveMap,
      createField,
      saveField,
    } = this.props;

    if (mode === "view") {
      return this.viewActions();
    } else if (mode === "editMap") {
      return (
        <SubmitButton
          disabled={false}
          submitting={submitting}
          onClick={saveMap}
        />
      );
    } else if (mode === "addField") {
      return (
        <SubmitButton
          disabled={!valid}
          submitting={submitting}
          onClick={createField}
        />
      );
    } else if (mode === "editField") {
      return (
        <SubmitButton
          disabled={!valid}
          submitting={submitting}
          onClick={saveField}
        />
      );
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
