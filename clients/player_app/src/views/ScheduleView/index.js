import React, { Component } from 'react';
import { connect } from 'react-redux';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListSubheader from '@material-ui/core/ListSubheader';
import Divider from '@material-ui/core/Divider';
import LocationIcon from '@material-ui/icons/LocationOn';
import moment from 'moment';
import { sortBy, groupBy} from 'lodash';
import gamesSearch from '../../helpers/gamesSearch';

class ScheduleView extends Component {
  render() {
    const { games, search } = this.props;
    const filteredGames = gamesSearch(search, games, { fuzzy: true });
    const sortedGames = sortBy(filteredGames, game =>
      moment.parseZone(game.startTime)
    );
    const gamesByStartTime = groupBy(sortedGames, game => game.startTime);

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
        {moment.parseZone(startTime).format('dddd h:mm A')}
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
                {game.field.name}
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
