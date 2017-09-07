import React, { Component } from 'react';
import { connect } from 'react-redux';
import { List, ListItem } from 'material-ui/List';
import Subheader from 'material-ui/Subheader';
import Divider from 'material-ui/Divider';
import PlaceIcon from 'material-ui/svg-icons/maps/place';
import moment from 'moment';
import _groupBy from 'lodash/groupBy';
import gamesSearch from '../helpers/gamesSearch';

class ScheduleList extends Component {
  render() {
    const { games, search } = this.props;
    const filteredGames = gamesSearch(search, games, { fuzzy: true });
    const gamesByStartTime = _groupBy(filteredGames, game => game.start_time);

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
      <Subheader>
        {moment(startTime).format('dddd h:mm A')}
      </Subheader>
      {games.map(game => {
        return (
          <ListItem key={game.id}>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <div>
                {game.home_name} vs {game.away_name}
              </div>
              <div>
                {game.field_name}
                <PlaceIcon />
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
