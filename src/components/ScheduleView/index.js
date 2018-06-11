import React, { Component } from 'react';
import { connect } from 'react-redux';
import List, { ListItem } from 'material-ui/List';
import ListSubheader from 'material-ui/List/ListSubheader';
import Divider from 'material-ui/Divider';
import LocationIcon from 'material-ui-icons/LocationOn';
import moment from 'moment';
import _sortBy from 'lodash/sortBy';
import _groupBy from 'lodash/groupBy';
import gamesSearch from '../../helpers/gamesSearch';

class ScheduleView extends Component {
  render() {
    const { games, search } = this.props;
    const filteredGames = gamesSearch(search, games, { fuzzy: true });
    const sortedGames = _sortBy(filteredGames, game => moment(game.startTime));
    const gamesByStartTime = _groupBy(sortedGames, game => game.startTime);

    return (
      <div>
        {Object.keys(gamesByStartTime).map(startTime => {
          const games = gamesByStartTime[startTime];
          return renderGameGroup(startTime, games);
        })}
        <div style={{ paddingBottom: 56 }} />
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
              {gameText(game)}
              <div>
                {game.fieldName}
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

function gameText(game) {
  if (game.scoreConfirmed) {
    let boldWinner;
    if (game.homeScore > game.awayScore) {
      boldWinner = (
        <span>
          <strong>{game.homeName}</strong> vs {game.awayName}
        </span>
      );
    } else if (game.awayScore > game.homeScore) {
      boldWinner = (
        <span>
          {game.homeName} vs <strong>{game.awayName}</strong>
        </span>
      );
    }

    return (
      <span>
        {boldWinner}
        <span>
          {' '}({game.homeScore} - {game.awayScore})
        </span>
      </span>
    );
  } else {
    return (
      <span>
        {game.homeName} vs {game.awayName}
      </span>
    );
  }
}

export default connect(state => ({
  games: state.tournament.games,
  search: state.search
}))(ScheduleView);
