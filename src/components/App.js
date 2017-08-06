import React, { Component } from 'react';
import { connect } from 'react-redux';

class App extends Component {
  render() {
    const { loading, games } = this.props;

    if (loading) {
      return <div>Loading ...</div>;
    }

    return (
      <div>
        {games.map(game => {
          return (
            <p key={game.id}>
              {game.id}
            </p>
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
