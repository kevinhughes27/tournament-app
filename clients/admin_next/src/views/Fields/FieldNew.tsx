import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import { Map, TileLayer, GeoJSON } from "react-leaflet";
import { OtherFieldStyle } from "./FieldStyle";

interface Props {
  map: FieldNew_map;
  fields: FieldNew_fields;
}

class FieldNew extends React.Component<Props> {
  render() {
    const { lat, long, zoom } = this.props.map;
    const { fields } = this.props;

    return (
      <div>
        <Map
          center={[lat, long]}
          zoom={zoom}
        >
          <TileLayer
            url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
            subdomains={["mt0", "mt1", "mt2", "mt3"]}
          />
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
