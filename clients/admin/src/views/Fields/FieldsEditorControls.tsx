import * as React from "react";
import { ReactLeafletSearch } from "react-leaflet-search";
import LocateControl from "react-leaflet-locate-control";
import Control from "react-leaflet-control";
import MapTooltip from "./MapTooltip";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faVectorSquare, faUndo, faTrash } from "@fortawesome/free-solid-svg-icons";

interface Props {
  mode: "none" | "view" | "editMap" | "addField" | "editField";
  squareFieldCorners: () => void;
  undoEdit: () => void;
  redrawField: () => void;
}

class FieldsEditorControls extends React.Component<Props> {
  render() {
    const { mode } = this.props;

    if (mode === "editMap") {
      return (
        <>
          <ReactLeafletSearch
            position="topleft"
            inputPlaceholder="Search Place or Lat, Lng"
            zoom={15}
            showMarker={false}
          />
          <LocateControl
            options={{
              position: "topleft",
              flyTo: true,
              drawCircle: false,
              drawMarker: false,
              icon: "material-icon-my-location",
              iconLoading: "material-icon-my-location",
              iconElementTag: "div",
              strings: {
                title: "Current location"
              },
              locateOptions: {
                maxZoom: 15
              }
            }}
          />
        </>
      );
    } else if ((mode === "addField" || mode === "editField"))  {
      return (
        <>
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
          <Control position="topleft">
            <MapTooltip text={"Redraw"}>
              <button className="fields-editor-control" onClick={this.props.redrawField}>
                <FontAwesomeIcon icon={faTrash} />
              </button>
            </MapTooltip>
          </Control>
        </>
      );
    } else {
      return null;
    }
  }
}

export default FieldsEditorControls;
