import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import { Map, TileLayer, FeatureGroup, GeoJSON } from "react-leaflet";
import { EditControl } from "react-leaflet-draw";
import * as L from "leaflet";
import { OtherFieldStyle } from "./FieldStyle";

// https://github.com/stefanocudini/orthogonalize-js

interface Props {
  map: FieldNew_map;
  fields: FieldNew_fields;
}

class FieldNew extends React.Component<Props> {
  mapRef: any;

  constructor(props: Props) {
    super(props);
    this.mapRef = React.createRef();
  }

  componentDidMount() {
    const map = this.mapRef.current.leafletElement;
    new L.Draw.Polygon(map).enable();
  }

  onCreate = (ev: L.DrawEvents.Created) => {
    const geoJson = ev.layer.toGeoJSON();
    const center = ev.layer.getCenter();
    debugger
  }

  render() {
    const { lat, long, zoom } = this.props.map;
    const { fields } = this.props;

    return (
      <div>
        <Map
          ref={this.mapRef}
          center={[lat, long]}
          zoom={zoom}
        >
          <TileLayer
            url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
            subdomains={["mt0", "mt1", "mt2", "mt3"]}
          />
          <FeatureGroup>
          <EditControl
            position="topright"
            onCreated={this.onCreate}
            draw={{
              polyline: false,
              polygon: false,
              rectangle: false,
              circle: false,
              marker: false,
              circlemarker: false
            }}
            edit={{
              edit: false,
              remove: false
            }}
          />
        </FeatureGroup>
          {fields.map(this.renderOtherFields)}
        </Map>
      </div>
    );
  }

  renderOtherFields = (field: FieldNew_fields[0]) => {
    return (
      <GeoJSON
        key={field.id}
        data={JSON.parse(field.geoJson)}
        style={OtherFieldStyle}
      />
    );
  }
}

export default createFragmentContainer(FieldNew, {
  map: graphql`
    fragment FieldNew_map on Map {
      lat
      long
      zoom
    }
  `,
  fields: graphql`
    fragment FieldNew_fields on Field @relay(plural: true) {
      id
      name
      lat
      long
      geoJson
    }
  `
});
