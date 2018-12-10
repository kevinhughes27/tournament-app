import * as React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faStop } from '@fortawesome/free-solid-svg-icons';
import { groupBy, map } from 'lodash';
import GameColor from './GameColor';

interface Props {
  games: UnscheduledGame[];
}

class Legend extends React.Component<Props> {
  render() {
    const games = this.props.games;
    const gamesByDivision = groupBy(games, g => g.division && g.division.name);

    return (
      <div style={{ paddingLeft: 20 }}>
        {map(gamesByDivision, this.renderDivision)}
      </div>
    );
  }

  renderDivision = (games: UnscheduledGame[], divisionName: string) => {
    const game = games[0];
    const color = GameColor(game);

    return (
      <span key={divisionName}>
        <h4>
          <FontAwesomeIcon icon={faStop} style={{ color }} /> {divisionName}
        </h4>
      </span>
    );
  };
}

export default Legend;
