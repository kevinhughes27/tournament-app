import * as React from "react";
import Geosuggest, { Suggest } from "react-geosuggest";
import TextField from "@material-ui/core/TextField";
import { FieldNameInput } from "../../assets/jss/styles";

interface Props {
  mode: "none" | "view" | "editMap" | "addField" | "editField";
  placeSelected: (lat: number, long: number) => void;
  name: string;
  updateName: (event: React.FormEvent<EventTarget>) => void;
}

class FieldsEditorControls extends React.Component<Props> {
  placeSelected = (suggest: Suggest) => {
    const location = suggest.location;

    const lat = parseFloat(location.lat);
    const long = parseFloat(location.lng);

    this.props.placeSelected(lat, long);
  }

  render() {
    const { mode, name, updateName } = this.props;

    if (mode === "editMap") {
      return (
        <Geosuggest
          className="leaflet-search"
          inputClassName="leaflet-search-input"
          suggestsClassName="leaflet-search-results"
          minLength={3}
          onSuggestSelect={this.placeSelected}
        />
      );
    } else if (mode === "addField" || mode === "editField") {
      return (
        <TextField
          name="name"
          label="Name"
          margin="normal"
          autoComplete="off"
          fullWidth
          style={FieldNameInput}
          InputLabelProps={{style: {paddingLeft: 10}}}
          value={name}
          onChange={updateName}
        />
      );
    } else {
      return null;
    }
  }
}

export default FieldsEditorControls;
