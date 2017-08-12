import React, { Component } from 'react';
import { connect } from 'react-redux';

import { Map, Marker, Popup, TileLayer } from 'react-leaflet';

class MapView extends Component {
  render() {
    const position = [51.505, -0.09];

    return (
      <div>
        <Map center={position} zoom={13}>
          <TileLayer
            url="http://{s}.tile.osm.org/{z}/{x}/{y}.png"
            attribution="&copy; <a href=&quot;http://osm.org/copyright&quot;>OpenStreetMap</a> contributors"
          />
          <Marker position={position}>
            <Popup>
              <span>
                A pretty CSS3 popup.<br />Easily customizable.
              </span>
            </Popup>
          </Marker>
        </Map>
      </div>
    );
  }
}

export default connect(state => ({
  games: state.app.games,
  search: state.app.search
}))(MapView);
