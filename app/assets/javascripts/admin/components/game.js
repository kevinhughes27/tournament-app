var React = require('react'),
    ReactDOM = require('react-dom'),
    Collapse = require('react-bootstrap').Collapse,
    classNames = require('classnames'),
    ScoreReports = require('./score_reports'),
    UpdateScoreModal = require('./update_score_modal'),
    GamesStore = require('../stores/games_store');

exports.NameCell = React.createClass({
  getInitialState() {
    var game = this.props.rowData;

    return {
      reportsOpen: game.reportsOpen || false
    };
  },

  _toggleCollapse(e) {
    e.nativeEvent.preventDefault();
    var game = this.props.rowData;
    var state = !this.state.reportsOpen;

    GamesStore.saveReportsState(game, state);
    this.setState({ reportsOpen: state });
  },

  renderReportsBadge(game) {
    var badgeText;
    var reportCount = game.score_reports.length;

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
      <ScoreDispute gameId={game.id} disputeId={game.dispute_id}/>
    );
  },

  render() {
    var game = this.props.rowData;
    var reports = game.score_reports;

    if (reports.length == 0) {
      var nameClasses = classNames({'subdued': !game.has_teams});
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
    var game = this.props.rowData;

    if (!game.has_teams) {
      return(<div></div>);
    };

    var text;
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
