import React, { Component } from 'react';
import { connect } from 'react-redux';
import { List, ListItem } from 'material-ui/List';
import Subheader from 'material-ui/Subheader';
import Divider from 'material-ui/Divider';
import SubmitModal from './SubmitModal';
import gamesSearch from '../helpers/gamesSearch';

class Submit extends Component {
  render() {
    const { games, search, dispatch } = this.props;
    const filteredGames = gamesSearch(search, games);

    return (
      <div>
        <Subheader>Submit a score for each game played</Subheader>
        <Divider />
        {renderGames(filteredGames, dispatch)}
      </div>
    );
  }
}

function renderGames(games, dispatch) {
  return (
    <List>
      {games.map(renderGame)}
    </List>
  );
}

function renderGame(game) {
  return (
    <ListItem key={game.id}>
      <SubmitModal game={game} />
    </ListItem>
  );
}

export default connect(state => ({
  games: state.app.games,
  search: state.app.search
}))(Submit);
