import React, { Component } from 'react';
import { connect } from 'react-redux';
import List, { ListItem } from 'material-ui/List';
import ListSubheader from 'material-ui/List/ListSubheader';
import Lock from './Lock';
import SubmitModal from './SubmitModal';
import gamesSearch from '../../helpers/gamesSearch';

class SubmitView extends Component {
  render() {
    const { search, games, reports } = this.props;

    if (this.props.protect) {
      return (
        <Lock>
          {renderContent(search, games, reports)}
        </Lock>
      );
    } else {
      return renderContent(search, games, reports);
    }
  }
}

function renderContent(search, games, reports) {
  const filteredGames = gamesSearch(search, games);

  return (
    <List>
      <ListSubheader>Submit a score for each game played</ListSubheader>
      {filteredGames.map(game => renderGame(game, reports))}
    </List>
  );
}

function renderGame(game, reports) {
  const filteredReports = reports.filter(r => r.game_id === game.id);
  const report = filteredReports[filteredReports.length - 1];

  return (
    <ListItem key={game.id}>
      <SubmitModal game={game} report={report} />
    </ListItem>
  );
}

export default connect(state => ({
  protect: state.tournament.settings.protectScoreSubmit,
  games: state.tournament.games,
  reports: state.reports,
  search: state.search
}))(SubmitView);
