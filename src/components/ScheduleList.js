import React, { Component } from 'react';
import { List, ListItem } from 'material-ui/List';
import Subheader from 'material-ui/Subheader';
import Divider from 'material-ui/Divider';
import moment from 'moment';
import _groupBy from 'lodash/groupBy';

class ScheduleList extends Component {
  render() {
    const { games } = this.props;
    const gamesByStartTime = _groupBy(games, game => game.start_time);

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
            {game.home_name} vs {game.away_name}
          </ListItem>
        );
      })}
      <Divider />
    </List>
  );
}

export default ScheduleList;
