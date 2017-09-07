import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Map, TileLayer, GeoJSON } from 'react-leaflet';
import gamesSearch from '../helpers/gamesSearch';
import moment from 'moment';
import _filter from 'lodash/filter';

class MapView extends Component {
  render() {
    const { map: { lat, long, zoom }, fields } = this.props;

    const { search, games } = this.props;
    const filteredGames = gamesSearch(search, games);

    const currentTime = moment();
    const currentGame = _filter(filteredGames, game => {
      const startTime = moment(game.start_time);
      const endTime = moment(game.end_time);
      return currentTime.isBetween(startTime && endTime);
    });

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
  map: state.app.map,
  fields: state.app.fields,
  games: state.app.games,
  search: state.app.search
}))(MapView);
