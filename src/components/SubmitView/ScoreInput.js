import React, { Component } from 'react';
import TextField from 'material-ui/TextField';

export default class ScoreInput extends Component {
  render() {
    const { game, homeScore, awayScore, onChange } = this.props;

    return (
      <div style={{ display: 'flex', justifyContent: 'space-around' }}>
        <TextField
          name="homeScore"
          type="number"
          autoComplete="off"
          value={homeScore}
          onChange={onChange}
          placeholder={game.homeName}
          style={{ flexBasis: '35%' }}
        />
        <TextField
          name="awayScore"
          type="number"
          autoComplete="off"
          value={awayScore}
          onChange={onChange}
          placeholder={game.awayName}
          style={{ flexBasis: '35%' }}
        />
      </div>
    );
  }
}
