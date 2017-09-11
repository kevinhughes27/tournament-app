import React, { Component } from 'react';
import { connect } from 'react-redux';
import List, { ListItem } from 'material-ui/List';
import ListSubheader from 'material-ui/List/ListSubheader';
import SubmitModal from './SubmitModal';
import gamesSearch from '../../helpers/gamesSearch';

class SubmitView extends Component {
  render() {
    const { games, search } = this.props;
    const filteredGames = gamesSearch(search, games);

    return (
      <List>
        <ListSubheader>Submit a score for each game played</ListSubheader>
        {filteredGames.map(renderGame)}
      </List>
    );
  }
}

function renderGame(game) {
  return (
    <ListItem key={game.id}>
      <SubmitModal game={game} />
    </ListItem>
  );
}

export default connect(state => ({
  games: state.tournament.games,
  search: state.search
}))(SubmitView);
