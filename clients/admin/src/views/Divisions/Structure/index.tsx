import * as React from 'react';
import Pools from './Pools';
import Bracket from './Bracket';

interface Props {
  games: any | string;
  bracketTree: string;
}

class Structure extends React.Component<Props> {
  render() {
    const bracketTree = this.props.bracketTree;
    let games = this.props.games;

    if (typeof games === 'string') {
      games = JSON.parse(games);
    }

    return (
      <>
        <Pools games={games} />
        <Bracket bracketTree={bracketTree} />
      </>
    );
  }
}

export default Structure;
