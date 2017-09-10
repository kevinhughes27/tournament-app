import React, { Component } from 'react';
import TextField from 'material-ui/TextField';

export default class ScoreInput extends Component {
  render() {
    const { game, home_score, away_score, onChange } = this.props;

    return (
      <div style={{ display: 'flex', justifyContent: 'space-around' }}>
        <TextField
          name="home_score"
          type="number"
          autoComplete="off"
          value={home_score}
          onChange={onChange}
          placeholder={game.home_name}
          style={{ flexBasis: '35%' }}
        />
        <TextField
          name="away_score"
          type="number"
          autoComplete="off"
          value={away_score}
          onChange={onChange}
          placeholder={game.away_name}
          style={{ flexBasis: '35%' }}
        />
      </div>
    );
  }
}
