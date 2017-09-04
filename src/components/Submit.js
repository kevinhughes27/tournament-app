import React, { Component } from 'react';
import { connect } from 'react-redux';
import { List, ListItem } from 'material-ui/List';
import AutoComplete from 'material-ui/AutoComplete';
import SubmitModal from './SubmitModal';
import _filter from 'lodash/filter';
import _uniq from 'lodash/uniq';

class Submit extends Component {
  render() {
    const { games, search, dispatch } = this.props;

    let filteredGames = [];
    if (search !== '') {
      filteredGames = _filter(games, game => {
        return (
          String(game.home_name).toLowerCase().indexOf(search.toLowerCase()) >=
            0 ||
          String(game.away_name).toLowerCase().indexOf(search.toLowerCase()) >=
            0
        );
      });
    }

    let searchItems = [];
    games.forEach(game => {
      searchItems.push(game.home_name);
      searchItems.push(game.away_name);
    });
    searchItems = _uniq(searchItems);

    return (
      <div>
        <AutoComplete
          hintText="Search Teams"
          dataSource={searchItems}
          filter={AutoComplete.caseInsensitiveFilter}
          searchText={search}
          openOnFocus={true}
          onUpdateInput={search => {
            dispatch({ type: 'SET_SEARCH', value: search });
          }}
        />
        <p>Submit a score for each game played</p>
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
