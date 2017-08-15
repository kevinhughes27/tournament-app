import React, { Component } from 'react';
import { connect } from 'react-redux';

import { Map, TileLayer } from 'react-leaflet';

class MapView extends Component {
  render() {
    const { lat, long, zoom } = window.tournament.map;

    return (
      <Map center={[lat, long]} zoom={zoom} zoomControl={false}>
        <TileLayer
          url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
          subdomains={['mt0', 'mt1', 'mt2', 'mt3']}
        />
      </Map>
    );
  }
}

export default connect(state => ({
  games: state.app.games,
  search: state.app.search
}))(MapView);
