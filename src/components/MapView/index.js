import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Map, TileLayer, GeoJSON, Popup } from 'react-leaflet';
import gamesSearch from '../../helpers/gamesSearch';
import moment from 'moment';
import _filter from 'lodash/filter';
import _sortBy from 'lodash/sortBy';
import _find from 'lodash/find';
import _get from 'lodash/get';

class MapView extends Component {
  render() {
    const { map: { lat, long, zoom }, fields } = this.props;

    const { search, games } = this.props;
    const filteredGames = gamesSearch(search, games);
    const sortedGames = _sortBy(filteredGames, game => moment(game.startTime));

    const nextGame = _filter(sortedGames, game => {
      const currentTime = moment();
      const startTime = moment(game.startTime);
      return currentTime.isBefore(startTime);
    })[0];
    const filteredFields = _filter(fields, field => field.geoJson);
    const nextFieldName = _get(nextGame, 'fieldName', -1);
    const nextField = _find(filteredFields, f => f.name === nextFieldName);

    return (
      <Map center={[lat, long]} zoom={zoom} zoomControl={false}>
        <TileLayer
          url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
          subdomains={['mt0', 'mt1', 'mt2', 'mt3']}
        />
        {renderFields(filteredFields, nextFieldName)}
        {renderPopup(nextGame, nextField)}
      </Map>
    );
  }
}

function renderFields(fields, nextFieldName) {
  return fields.map(field => {
    let style = () => {
      if (field.name === nextFieldName) {
        return { color: 'white' };
      } else {
        return { color: 'rgb(51, 136, 255)' };
      }
    };

    return (
      <GeoJSON key={field.id} data={JSON.parse(field.geoJson)} style={style} />
    );
  });
}

function renderPopup(nextGame, nextField) {
  if (nextGame && nextField) {
    return (
      <Popup position={[nextField.lat, nextField.long]}>
        <span>
          {nextGame.homeName} vs {nextGame.awayName}
          <br />
          <strong>@ {moment(nextGame.startTime).format('h:mm')}</strong>
        </span>
      </Popup>
    );
  }
}

export default connect(state => ({
  map: state.tournament.map,
  fields: state.tournament.fields,
  games: state.tournament.games,
  search: state.search
}))(MapView);
