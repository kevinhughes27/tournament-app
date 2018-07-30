import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import { Map, TileLayer, GeoJSON } from "react-leaflet";
import { OtherFieldStyle, FieldStyle } from "./FieldStyle";
import Breadcrumbs from "../../components/Breadcrumbs";

interface Props {
  map: FieldShow_map;
  field: FieldShow_field;
  fields: FieldShow_fields;
}

class FieldShow extends React.Component<Props> {
  render() {
    const { lat, long, zoom } = this.props.map;
    const { field, fields } = this.props;

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/fields", text: "Fields"},
            {text: field.name}
          ]}
        />
        <Map
          center={[lat, long]}
          zoom={zoom}
        >
          <TileLayer
            url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
            subdomains={["mt0", "mt1", "mt2", "mt3"]}
          />
          {this.renderField(field)}
          {fields.map(this.renderOtherFields)}
        </Map>
      </div>
    );
  }

  renderField = (field: FieldShow_field) => (
    <GeoJSON
      key={field.id}
      data={JSON.parse(field.geoJson)}
      style={FieldStyle}
    />
  )

  renderOtherFields = (field: FieldShow_fields[0]) => {
    if (field.id === this.props.field.id) {
      return null;
    }

    return (
      <GeoJSON
        key={field.id}
        data={JSON.parse(field.geoJson)}
        style={OtherFieldStyle}
      />
    );
  }
}

export default createFragmentContainer(FieldShow, {
  map: graphql`
    fragment FieldShow_map on Map {
      lat
      long
      zoom
    }
  `,
  field: graphql`
    fragment FieldShow_field on Field {
      id
      name
      lat
      long
      geoJson
    }
  `,
  fields: graphql`
    fragment FieldShow_fields on Field @relay(plural: true) {
      id
      name
      lat
      long
      geoJson
    }
  `
});
