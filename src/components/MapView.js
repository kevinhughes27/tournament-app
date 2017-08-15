import React, { Component } from 'react';
import { connect } from 'react-redux';

import { Map, TileLayer, GeoJSON } from 'react-leaflet';

class MapView extends Component {
  render() {
    const { lat, long, zoom } = window.tournament.map;
    const fields = this.props.fields;

    return (
      <Map center={[lat, long]} zoom={zoom} zoomControl={false}>
        <TileLayer
          url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
          subdomains={['mt0', 'mt1', 'mt2', 'mt3']}
        />
        {renderFields(fields)}
      </Map>
    );
  }
}

function renderFields(fields) {
  return fields.map(field => {
    return <GeoJSON key={field.id} data={JSON.parse(field.geo_json)} />;
  });
}

export default connect(state => ({
  fields: state.app.fields,
  search: state.app.search
}))(MapView);
