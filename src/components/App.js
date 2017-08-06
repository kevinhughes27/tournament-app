import React, { Component } from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import { connect } from 'react-redux';
import { List, ListItem } from 'material-ui/List';
import Subheader from 'material-ui/Subheader';
import Divider from 'material-ui/Divider';
import _groupBy from 'lodash/groupBy';

class App extends Component {
  render() {
    const { loading, games } = this.props;

    if (loading) {
      return <div>Loading ...</div>;
    }

    const gamesByStartTime = _groupBy(games, game => game.start_time);

    return (
      <MuiThemeProvider>
        <div>
          {Object.keys(gamesByStartTime).map(startTime => {
            const games = gamesByStartTime[startTime];
            return renderGameGroup(startTime, games);
          })}
        </div>
      </MuiThemeProvider>
    );
  }
}

function renderGameGroup(startTime, games) {
  return (
    <List key={startTime}>
      <Subheader>
        {startTime}
      </Subheader>
      {games.map(game => {
        return (
          <ListItem key={game.id}>
            {game.id}
          </ListItem>
        );
      })}
      <Divider />
    </List>
  );
}

export default connect(state => ({
  loading: state.loading,
  games: state.games
}))(App);
