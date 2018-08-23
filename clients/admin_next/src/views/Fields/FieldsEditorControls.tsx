import * as React from "react";
import Control from "react-leaflet-control";
import MapTooltip from "./MapTooltip";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faVectorSquare, faUndo } from "@fortawesome/free-solid-svg-icons";

interface Props {
  mode: "none" | "view" | "editMap" | "addField" | "editField";
  geojson: string;
  squareFieldCorners: () => void;
  undoEdit: () => void;
}

class FieldsEditorControls extends React.Component<Props> {
  render() {
    const { mode, geojson } = this.props;

    if ((mode === "addField" || mode === "editField") && geojson !== "")  {
      return (
        <div>
          <Control position="topleft">
            <MapTooltip text={"Square Corners"}>
              <button className="fields-editor-control" onClick={this.props.squareFieldCorners}>
                <FontAwesomeIcon icon={faVectorSquare} />
              </button>
            </MapTooltip>
          </Control>
          <Control position="topleft">
            <MapTooltip text={"Undo"}>
              <button className="fields-editor-control" onClick={this.props.undoEdit}>
                <FontAwesomeIcon icon={faUndo} />
              </button>
            </MapTooltip>
          </Control>
        </div>
      );
    } else {
      return null;
    }
  }
}

export default FieldsEditorControls;
