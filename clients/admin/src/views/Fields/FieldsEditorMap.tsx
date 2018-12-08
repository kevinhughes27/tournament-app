import * as React from "react";
import { LeafletGeoJSONEvent, Polygon } from "leaflet";
import { Map, TileLayer, GeoJSON } from "react-leaflet";
import MapLabel from "./MapLabel";
import { FieldStyle, FieldHoverStyle } from "./FieldStyle";
import "leaflet-editable";

interface Props {
  lat: number;
  long: number;
  zoom: number;
  fields: FieldsEditorQuery["fields"];
  updateMap: (ev: any) => void;
  editField: (field: FieldsEditorQuery_fields) => void;
}

type Ref = Map<any>;

const FieldsEditorMap = React.forwardRef<Ref, Props>((props, ref) => (
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
    {(props.fields || []).map((field) => (
      <GeoJSON
        key={field.id}
        data={JSON.parse(field.geoJson)}
        style={FieldStyle}
        onMouseover={(ev: LeafletGeoJSONEvent) => {
          const polygon = ev.layer as Polygon;
          polygon.setStyle(FieldHoverStyle);
        }}
        onMouseout={(ev: LeafletGeoJSONEvent) => {
          const polygon = ev.layer as Polygon;
          polygon.setStyle(FieldStyle);
        }}
        onClick={() => {
          props.editField(field);
        }}
      />
    ))}
    {(props.fields || []).map(MapLabel)}
    {props.children}
  </Map>
));

export default FieldsEditorMap;
