import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Map, TileLayer, GeoJSON } from 'react-leaflet';
import gamesSearch from '../helpers/gamesSearch';
import moment from 'moment';
import _filter from 'lodash/filter';
import _sortBy from 'lodash/sortBy';
import _get from 'lodash/get';

class MapView extends Component {
  render() {
    const { map: { lat, long, zoom }, fields } = this.props;

    const { search, games } = this.props;
    const filteredGames = gamesSearch(search, games);
    const sortedGames = _sortBy(filteredGames, game => moment(game.start_time));

    const currentTime = moment();
    const nextGame = _filter(sortedGames, game => {
      const startTime = moment(game.start_time);
      return currentTime.isBefore(startTime);
    })[0];
    const currentFieldName = _get(nextGame, 'field_name', -1);

    return (
      <Map center={[lat, long]} zoom={zoom} zoomControl={false}>
        <TileLayer
          url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
          subdomains={['mt0', 'mt1', 'mt2', 'mt3']}
        />
        {renderFields(fields, currentFieldName)}
      </Map>
    );
  }
}

function renderFields(fields, currentFieldName) {
  return fields.map(field => {
    let style = {};
    if (field.name === currentFieldName) {
      style = { color: 'white' };
    }

    return (
      <GeoJSON key={field.id} data={JSON.parse(field.geo_json)} style={style} />
    );
  });
}

export default connect(state => ({
  map: state.app.map,
  fields: state.app.fields,
  games: state.app.games,
  search: state.app.search
}))(MapView);
