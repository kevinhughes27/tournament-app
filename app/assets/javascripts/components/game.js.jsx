var _ = require('underscore'),
    React = require('react'),
    Collapse = require('react-bootstrap').Collapse,
    Popover = require('react-bootstrap').Popover,
    OverlayTrigger = require('react-bootstrap').OverlayTrigger,
    classNames = require('classnames'),
    ScoreReports = require('./score_reports');

var Game = React.createClass({
  render() {
    var gameIdx = this.props.gameIdx;
    var games = this.props.gamesIndex.state.games;
    var game = games[gameIdx];

    var sotgWarning = _.some(game.score_reports, function(report){ return report.sotg_warning });

    return (
      <tr className={ classNames({warning: sotgWarning}) }>
        <td className="col-md-7 table-link">
          <NameRow name={game.name} reports={game.score_reports} gamesIndex={this.props.gamesIndex} />
        </td>
        <td className="col-md-2">
          {game.division}
        </td>
        <td className="col-md-1 table-link">
          <ScoreFormPopover game={game} gamesIndex={this.props.gamesIndex} />
        </td>
        <td className="col-md-2">
          <ConfirmRow confirmed={game.confirmed} played={game.played} />
        </td>
      </tr>
    );
  }
});

var NameRow = React.createClass({
  getInitialState() {
    return {
      reportsOpen: false
    };
  },

  _toggleCollapse(e) {
    e.nativeEvent.preventDefault();
    this.setState({ reportsOpen: !this.state.reportsOpen });
  },

  render() {
    var name = this.props.name;
    var reports = this.props.reports;

    if (reports.length == 0) {
      return( <span>{name}</span> );
    };

    return (
      <div>
        <a href="#" onClick={this._toggleCollapse}>
          {name + " "}
          <span className="badge">{reports.length}</span>
        </a>
        <Collapse in={this.state.reportsOpen}>
          <div>
            <ScoreReports reports={reports} gamesIndex={this.props.gamesIndex}/>
          </div>
        </Collapse>
      </div>
    );
  }
});

var ScoreFormPopover = React.createClass({
  render() {
    var game = this.props.game;

    var scoreForm = <Popover title={game.name}>
      <ScoreForm gameId={game.id}
                 homeScore={game.home_score}
                 awayScore={game.away_score}
                 gamesIndex={this.props.gamesIndex} />
    </Popover>;

    return (
      <OverlayTrigger trigger="click" overlay={scoreForm}>
        <a href="#">{game.score}</a>
      </OverlayTrigger>
    );
  }
});

var ScoreForm = React.createClass({
  getInitialState() {
    return {
      isLoading: false,
      homeScore: this.props.homeScore,
      awayScore: this.props.awayScore
    };
  },

  _startLoading() {
    Turbolinks.ProgressBar.start()
    this.setState({isLoading: true});
  },

  _finishLoading() {
    Turbolinks.ProgressBar.done()
    this.setState({isLoading: false});
  },

  updateScore() {
    this._startLoading();

    $.ajax({
      url: 'games/' + this.props.gameId + '.json',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: this.state.homeScore,
        away_score: this.state.awayScore
      },
      success: this.updateFinished
    })
  },

  updateFinished(response) {
    this._finishLoading();
    this.props.gamesIndex.updateGame(response.game);
  },

  render() {
    var btnClasses = classNames('btn', 'btn-default', {'is-loading': this.state.isLoading});

    return (
      <form className="form-inline">
        <input type="number"
               value={this.state.homeScore}
               className="form-control score-input"
               onChange={ (e) => {
                 this.setState({homeScore: e.target.valueAsNumber})
               }}/>
        <span> &mdash; </span>
        <input type="number"
               value={this.state.awayScore}
               className="form-control score-input"
               onChange={ (e) => {
                 this.setState({awayScore: e.target.valueAsNumber})
               }}/>
        <button className={btnClasses} onClick={this.updateScore}>
          Save
        </button>
      </form>
    );
  }
});

var ConfirmRow = React.createClass({
  render() {
    var iconClass;
    var iconColor;

    if(this.props.confirmed) {
      iconClass = "fa fa-check";
      iconColor = "green";
    } else if(this.props.played) {
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

module.exports = Game;
