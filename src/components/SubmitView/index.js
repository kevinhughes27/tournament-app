import React, { Component } from 'react';
import { connect } from 'react-redux';
import List, { ListItem } from 'material-ui/List';
import ListSubheader from 'material-ui/List/ListSubheader';
import Lock from './Lock';
import SubmitModal from './SubmitModal';
import gamesSearch from '../../helpers/gamesSearch';
import _find from 'lodash/find';

class SubmitView extends Component {
  render() {
    const { search, teams, games, reports } = this.props;

    if (this.props.protect) {
      return (
        <Lock>
          {renderContent(search, games, reports)}
        </Lock>
      );
    } else {
      return renderContent(search, teams, games, reports);
    }
  }
}

function renderContent(search, teams, games, reports) {
  const filteredGames = gamesSearch(search, games);

  if (search === '') {
    return <div className="center">Please search for your team</div>;
  } else if (filteredGames.length === 0) {
    return (
      <div className="center">
        No games found for team '{search}'
      </div>
    );
  } else {
    return renderGames(search, teams, games, reports);
  }
}

function renderGames(search, teams, games, reports) {
  const teamName = search;
  const team = _find(teams, t => t.name === teamName);

  return (
    <div>
      <List>
        <ListSubheader>Submit a score for each game played</ListSubheader>
        {games.map(game => renderGame(team, game, reports))}
      </List>
      <div style={{ paddingBottom: 56 }} />
    </div>
  );
}

function renderGame(team, game, reports) {
  const filteredReports = reports.filter(
    r => parseInt(r.gameId, 10) === parseInt(game.id, 10)
  );
  const report = filteredReports[filteredReports.length - 1];

  return (
    <ListItem key={game.id}>
      <SubmitModal team={team} game={game} report={report} />
    </ListItem>
  );
}

export default connect(state => ({
  protect: state.tournament.settings.protectScoreSubmit,
  teams: state.tournament.teams,
  games: state.tournament.games,
  reports: state.reports,
  search: state.search
}))(SubmitView);
