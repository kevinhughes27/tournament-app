import React, { Component } from 'react';
import { connect } from 'react-redux';
import List, { ListItem } from 'material-ui/List';
import ListSubheader from 'material-ui/List/ListSubheader';
import { Done, Cached, ReportProblem } from 'material-ui-icons';
import SubmitModal from './SubmitModal';
import gamesSearch from '../../helpers/gamesSearch';

class SubmitView extends Component {
  render() {
    const { search, games, reports } = this.props;
    const filteredGames = gamesSearch(search, games);

    return (
      <List>
        <ListSubheader>Submit a score for each game played</ListSubheader>
        {filteredGames.map(game => renderGame(game, reports))}
      </List>
    );
  }
}

function renderGame(game, reports) {
  const filteredReports = reports.filter(r => r.game_id === game.id);
  const report = filteredReports[filteredReports.length - 1];

  return (
    <ListItem key={game.id}>
      <SubmitModal game={game} report={report} />
      {renderReport(report)}
    </ListItem>
  );
}

function renderReport(report) {
  if (report) {
    const statusToIcon = {
      null: null,
      pending: <Cached />,
      success: <Done />,
      error: <ReportProblem />
    };
    return statusToIcon[report.status];
  }
}

export default connect(state => ({
  games: state.tournament.games,
  reports: state.reports,
  search: state.search
}))(SubmitView);
