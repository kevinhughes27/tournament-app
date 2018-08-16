import * as React from "react";
import { Map, TileLayer, GeoJSON } from "react-leaflet";
import { FieldStyle, FieldHoverStyle } from "./FieldStyle";
import "leaflet-editable";

interface Props {
  lat: number;
  long: number;
  zoom: number;
  fields: FieldsEditor_fields;
  updateMap: (ev: any) => void;
  editField: (field: FieldsEditor_fields[0], layer: any) => void;
}

const FieldsEditorMap = React.forwardRef((props: Props, ref: any) => (
  <Map
    ref={ref}
    center={[props.lat, props.long]}
    zoom={props.zoom}
    maxZoom={20}
    doubleClickZoom={false}
    onDrag={props.updateMap}
    onZoom={props.updateMap}
    editable={true}
    editOptions={{
      skipMiddleMarkers: true
    }}
  >
    <TileLayer
      url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
      subdomains={["mt0", "mt1", "mt2", "mt3"]}
    />
    {props.fields.map((field) => (
      <GeoJSON
        key={field.id}
        data={JSON.parse(field.geoJson)}
        style={FieldStyle}
        onMouseover={(ev: any) => ev.layer.setStyle(FieldHoverStyle)}
        onMouseout={(ev: any) => ev.layer.setStyle(FieldStyle)}
        onClick={(ev: any) => props.editField(field, ev.layer)}
      />
    ))}
  </Map>
));

export default FieldsEditorMap;
