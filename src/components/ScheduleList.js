import React, { Component } from 'react';
import { connect } from 'react-redux';
import List, { ListItem } from 'material-ui/List';
import ListSubheader from 'material-ui/List/ListSubheader';
import Divider from 'material-ui/Divider';
import LocationIcon from 'material-ui-icons/LocationOn';
import moment from 'moment';
import _sortBy from 'lodash/sortBy';
import _groupBy from 'lodash/groupBy';
import gamesSearch from '../helpers/gamesSearch';

class ScheduleList extends Component {
  render() {
    const { games, search } = this.props;
    const filteredGames = gamesSearch(search, games, { fuzzy: true });
    const sortedGames = _sortBy(filteredGames, game => moment(game.start_time));
    const gamesByStartTime = _groupBy(sortedGames, game => game.start_time);

    return (
      <div>
        {Object.keys(gamesByStartTime).map(startTime => {
          const games = gamesByStartTime[startTime];
          return renderGameGroup(startTime, games);
        })}
      </div>
    );
  }
}

function renderGameGroup(startTime, games) {
  return (
    <List key={startTime}>
      <ListSubheader>
        {moment(startTime).format('dddd h:mm A')}
      </ListSubheader>
      {games.map(game => {
        return (
          <ListItem key={game.id}>
            <div
              style={{
                display: 'flex',
                flex: 1,
                justifyContent: 'space-between'
              }}
            >
              <div>
                {game.home_name} vs {game.away_name}
              </div>
              <div>
                {game.field_name}
                <LocationIcon />
              </div>
            </div>
          </ListItem>
        );
      })}
      <Divider />
    </List>
  );
}

export default connect(state => ({
  games: state.app.games,
  search: state.app.search
}))(ScheduleList);
