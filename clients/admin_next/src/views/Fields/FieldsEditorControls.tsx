import * as React from "react";
import Control from "react-leaflet-control";

interface Props {
  mode: "none" | "view" | "editMap" | "addField" | "editField";
  geojson: string;
  squareOffField: () => void;
}

class FieldsEditorControls extends React.Component<Props> {
  render() {
    const { mode, geojson } = this.props;

    if ((mode === "addField" || mode === "editField") && geojson !== "")  {
      return (
        <Control position="topleft">
          <button onClick={this.props.squareOffField}>
            Square
          </button>
        </Control>
      );
    } else {
      return null;
    }
  }
}

export default FieldsEditorControls;
