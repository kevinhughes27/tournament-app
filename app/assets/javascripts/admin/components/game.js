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

  render() {
    var game = this.props.rowData;
    var name = game.name;
    var reports = game.score_reports;

    var nameClasses = classNames({'subdued': !game.has_teams});

    if (reports.length == 0) {
      return( <span className={nameClasses}>{name}</span> );
    };

    return (
      <div>
        <a href="#" onClick={this._toggleCollapse}>
          {name + " "}
          <span className="badge">{reports.length}</span>
        </a>
        <Collapse in={this.state.reportsOpen}>
          <div>
            <ScoreReports reports={reports}/>
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
    if(game.has_score) {
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

exports.ConfirmedCell = React.createClass({
  render() {
    var game = this.props.rowData;
    var iconClass;
    var iconColor;

    if(game.confirmed) {
      iconClass = "fa fa-check";
      iconColor = "green";
    } else if(game.played) {
      iconClass = "fa fa-exclamation-circle";
      iconColor = 'orange';
    } else {
      iconClass = "fa fa-question-circle";
      iconColor ="#008B8B";
    };

    return (
      <i className={iconClass} style={{color: iconColor}}></i>
    );
  }
});
