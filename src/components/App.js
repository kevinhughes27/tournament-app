import React, { Component } from 'react';
import { connect } from 'react-redux';
import _groupBy from 'lodash/groupBy';

class App extends Component {
  render() {
    const { loading, games } = this.props;

    if (loading) {
      return <div>Loading ...</div>;
    }

    const gamesByStartTime = _groupBy(games, game => game.start_time);

    return (
      <div>
        {Object.keys(gamesByStartTime).map(startTime => {
          const games = gamesByStartTime[startTime];
          return (
            <div>
              <p>
                {startTime}
              </p>
              {games.map(game => {
                return (
                  <p key={game.id}>
                    {game.id}
                  </p>
                );
              })}
            </div>
          );
        })}
      </div>
    );
  }
}

export default connect(state => ({
  loading: state.loading,
  games: state.games
}))(App);
