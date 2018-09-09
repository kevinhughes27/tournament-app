import * as React from "react";
import TextField from "@material-ui/core/TextField";

interface Props {
  mode: "none" | "view" | "editMap" | "addField" | "editField";
  name: string;
  updateName: (event: React.FormEvent<EventTarget>) => void;
  nameError?: UserError;
}

const style = {
  position: "absolute" as "absolute",
  zIndex: 1000,
  backgroundColor: "white",
  width: 240,
  left: 60,
  paddingLeft: 10
};

class FieldsEditorInput extends React.Component<Props> {
  render() {
    const { mode, name, updateName } = this.props;

    if (mode === "addField" || mode === "editField") {
      return (
        <TextField
          name="name"
          label="Name"
          margin="normal"
          autoComplete="off"
          fullWidth
          style={style}
          InputProps={{disableUnderline: true}}
          InputLabelProps={{style: {paddingLeft: 10}}}
          value={name}
          onChange={updateName}
          helperText={this.props.nameError && this.props.nameError.message}
        />
      );
    } else {
      return null;
    }
  }
}

export default FieldsEditorInput;
