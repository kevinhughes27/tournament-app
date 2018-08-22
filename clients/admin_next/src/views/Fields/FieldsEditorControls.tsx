import * as React from "react";
import Control from "react-leaflet-control";
import MapTooltip from "./MapTooltip";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faVectorSquare } from "@fortawesome/free-solid-svg-icons";

interface Props {
  mode: "none" | "view" | "editMap" | "addField" | "editField";
  geojson: string;
  squareFieldCorners: () => void;
}

class FieldsEditorControls extends React.Component<Props> {
  render() {
    const { mode, geojson } = this.props;

    if ((mode === "addField" || mode === "editField") && geojson !== "")  {
      return (
        <Control position="topleft">
          <MapTooltip text={"Square Corners"}>
            <button className="fields-editor-control" onClick={this.props.squareFieldCorners}>
              <FontAwesomeIcon icon={faVectorSquare} />
            </button>
          </MapTooltip>
        </Control>
      );
    } else {
      return null;
    }
  }
}

export default FieldsEditorControls;
