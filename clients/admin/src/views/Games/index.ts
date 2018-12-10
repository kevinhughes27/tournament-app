import * as React from 'react';
import { query } from '../../queries/GamesListQuery';
import renderQuery from '../../helpers/renderQuery';
import GameList from './GameList';

class Games extends React.Component {
  render() {
    return renderQuery(query, {}, GameList, {
      fetchPolicy: 'cache-and-network'
    });
  }
}

export default Games;
