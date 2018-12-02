import * as React from "react";
import DivIcon from "react-leaflet-div-icon";

const MapLabel = (field: FieldsEditor_fields[0]) => (
  <DivIcon key={field.id} position={{lat: field.lat, lng: field.long}} className="map-label">
    <span>{field.name}</span>
  </DivIcon>
);

export default MapLabel;
