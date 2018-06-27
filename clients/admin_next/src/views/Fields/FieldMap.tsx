import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Map, TileLayer, GeoJSON } from "react-leaflet";

const styles = {};
const fieldStyle = () => {
  return { color: "rgb(51, 136, 255)" };
};

interface Props extends WithStyles<typeof styles> {
  map: MapType;
  fields: Field[];
}

class FieldMap extends React.Component<Props> {
  render() {
    const { map: { lat, long, zoom }, fields } = this.props;

    return (
      <Map center={[lat, long]} zoom={zoom} zoomControl={false}>
        <TileLayer
          url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
          subdomains={["mt0", "mt1", "mt2", "mt3"]}
        />
        {fields.map((field: any) => Field(field))}
      </Map>
    );
  }
}

const Field = (field: any) => (
  <GeoJSON key={field.id} data={JSON.parse(field.geoJson)} style={fieldStyle} />
);

const StyledFieldMap = withStyles(styles)(FieldMap);

export default createFragmentContainer(StyledFieldMap, {
  map: graphql`
    fragment FieldMap_map on Map {
      lat
      long
      zoom
    }
  `,
  fields: graphql`
    fragment FieldMap_fields on Field @relay(plural: true) {
      id
      name
      lat
      long
      geoJson
    }
  `
});
