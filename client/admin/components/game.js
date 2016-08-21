import React from 'react';
import ReactDOM from 'react-dom';
import {Collapse} from 'react-bootstrap';
import classNames from 'classnames';
import ScoreReports from './score_reports';
import ScoreDispute from './score_dispute';
import UpdateScoreModal from './update_score_modal';
import GamesStore from '../stores/games_store';

exports.NameCell = React.createClass({
  getInitialState() {
    let game = this.props.rowData;

    return {
      reportsOpen: game.reportsOpen || false
    };
  },

  _toggleCollapse(e) {
    e.nativeEvent.preventDefault();
    let game = this.props.rowData;
    let state = !this.state.reportsOpen;

    GamesStore.saveReportsState(game, state);
    this.setState({ reportsOpen: state });
  },

  renderReportsBadge(game) {
    let badgeText;
    let reportCount = game.score_reports.length;

    // if the game is not confirmed but there is a report
    // then we know we need 2 reports
    if (game.confirmed) {
      badgeText = reportCount
    } else {
      badgeText = `${reportCount} / 2`
    };

    return (
      <span className="badge">
        {badgeText}
      </span>
    );
  },

  renderDisputeBadge(game) {
    if (!game.has_dispute) {
      return;
    }

    return (
      <i className="fa fa-lg fa-exclamation-triangle" style={{color: 'orange'}}></i>
    );
  },

  renderBadges(game) {
    return (
      <span>{this.renderReportsBadge(game)} {this.renderDisputeBadge(game)}
      </span>
    );
  },

  renderDispute(game) {
    if (!game.has_dispute) {
      return;
    }

    return (
      <ScoreDispute game={game}/>
    );
  },

  render() {
    let game = this.props.rowData;
    let reports = game.score_reports;

    if (reports.length == 0) {
      let nameClasses = classNames({'subdued': !game.has_teams});
      return( <span className={nameClasses}>{game.name}</span> );
    };

    return (
      <div>
        <a href="#" onClick={this._toggleCollapse}>
          <span>{game.name} {this.renderBadges(game)}</span>
        </a>
        <Collapse in={this.state.reportsOpen}>
          <div>
            <ScoreReports reports={reports}/>
            {this.renderDispute(game)}
          </div>
        </Collapse>
      </div>
    );
  }
});

exports.ScoreCell = React.createClass({
  render() {
    let game = this.props.rowData;

    if (!game.has_teams) {
      return(<div></div>);
    };

    let text;
    if(game.confirmed) {
      text = `${game.home_score} - ${game.away_score}`;
    } else {
      text = <i className="fa fa-plus-square-o"></i>;
    }

    return (
      <UpdateScoreModal game={game}
                        linkText={text}
                        linkClass="btn-inline"/>
    );
  }
});
