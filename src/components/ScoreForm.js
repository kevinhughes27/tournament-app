import React, { Component } from 'react';
import { connect } from 'react-redux';
import _find from 'lodash/find';

class ScoreForm extends Component {
  render() {
    const gameId = this.props.match.params.gameId;
    const game = _find(this.props.games, g => g.id === gameId);

    return (
      <div>
        {game.home_name} vs {game.away_name}
      </div>
    );
  }
}

export default connect(state => ({
  games: state.app.games,
  search: state.app.search
}))(ScoreForm);
