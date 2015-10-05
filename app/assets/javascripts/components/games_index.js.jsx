var _ = require("underscore");
var $ = require("jquery");
var React = require('react');
var Collapse = require('react-bootstrap').Collapse;
var classNames = require('classnames');

var GamesIndex = React.createClass({
  getInitialState() {
    return {
      games: this.props.games,
      searchString: '',
      sortBy: '',
      sortReverse: false
    };
  },

  searchUpdated(event) {
    var val = event.target.value;
    val = val.replace("\\", "");
    this.setState({searchString: val});
  },

  searchFilter(games, searchString) {
    return _.filter(games, function(game) {
      return game.name.match(searchString) ||
             game.home.match(searchString) ||
             game.away.match(searchString);
    });
  },

  sortUpdated(field) {
    if(field == this.state.sortBy) {
      this.setState({
        sortBy: field,
        sortReverse: !this.state.sortReverse
      });
    } else {
      this.setState({
        sortBy: field,
        sortReverse: false
      });
    }
  },

  sortFilter(games, field, reverse) {
    if(reverse){
      return _.sortBy(games, field).reverse();
    } else {
      return _.sortBy(games, field);
    }
  },

  updateGame(updatedGame) {
    var games = this.state.games;

    var idx = _.findIndex(games, function(game){
      return game.id == updatedGame.id;
    });

    games[idx] = updatedGame;
    this.setState({games: games});
  },

  render() {
    var games = this.state.games;
    var searchString = this.state.searchString;
    var sortBy = this.state.sortBy;
    var sortReverse = this.state.sortReverse;

    if(searchString) {
      games = this.searchFilter(games, searchString);
    };

    if(sortBy) {
      games = this.sortFilter(games, sortBy, sortReverse);
    };

    return (
      <div>
        <div className="input-group" style={{paddingBottom: '15px'}}>
          <div className="input-group-addon">
            <i className="fa fa-search"></i>
          </div>
          <input className="search form-control"
                 value={searchString}
                 placeholder="Search"
                 onChange={this.searchUpdated}/>
        </div>
        <table className="table table-striped table-hover">
          <thead>
            <tr>
              <th className="sort-header">
                <a href="#" className="sort" onClick={this.sortUpdated.bind(this, "name")}>
                  Game
                </a>
              </th>
              <th className="sort-header">
                <a href="#" className="sort" onClick={this.sortUpdated.bind(this, "division")}>
                  Division
                </a>
              </th>
              <th>Score</th>
              <th className="sort-header">
                <a href="#" className="sort" onClick={this.sortUpdated.bind(this, "confirmed")}>
                  Confirmed
                </a>
              </th>
            </tr>
          </thead>
          <tbody>
            { games.map((game) => {
              return <Game game={game} gamesIndex={this}/>;
            })}
          </tbody>
        </table>
      </div>
    );
  }
});

var Game = React.createClass({
  getInitialState() {
    return {
      reportsOpen: false,
    };
  },

  _toggleCollapse(e) {
    e.nativeEvent.preventDefault();
    this.setState({ reportsOpen: !this.state.reportsOpen });
  },

  render() {
    var game = this.props.game;
    var reportsOpen = this.state.reportsOpen;

    var nameRow;
    if (game.score_reports.length > 0) {
      nameRow = <div>
        <a href="#" onClick={this._toggleCollapse}>
          {game.name + " "}
          <span className="badge"> {game.score_reports.length} </span>
        </a>
        <Collapse in={this.state.reportsOpen}>
          <div>
            <ScoreReports reports={game.score_reports} gamesIndex={this.props.gamesIndex}/>
          </div>
        </Collapse>
      </div>
    } else {
      nameRow = game.name;
    };

    var confirmRow;
    if(game.confirmed) {
      confirmRow = <i className="fa fa-check" style={{color: 'green'}}></i>;
    } else {
      confirmRow = <i className="fa fa-exclamation-circle" style={{color: 'orange'}}></i>;
    };

    return (
      <tr>
        <td className="col-md-7 table-link">
          {nameRow}
        </td>
        <td className="col-md-2">
          {game.division}
        </td>
        <td className="col-md-1 table-link">
          {game.score}
        </td>
        <td className="col-md-2">
          {confirmRow}
        </td>
      </tr>
    );
  }
});

var ScoreReports = React.createClass({
  render() {
    var reports = this.props.reports;

    return (
      <div style={{paddingTop: 25}}>
        <div className="panel panel-default">
          <div className="panel-heading">Score Reports</div>
          <table className="table table-striped table-hover">
            <thead>
              <tr>
                <th>Score</th>
                <th>Submitted by</th>
                <th>Submitted at</th>
                <th>SOTG</th>
                <th>Comments</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              { reports.map((report) => {
                return <ScoreReport report={report} gamesIndex={this.props.gamesIndex}/>;
              })}
            </tbody>
          </table>
        </div>
      </div>
    );
  }
});

var ScoreReport = React.createClass({
  getInitialState() {
    return {
      isLoading: false
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

  acceptScoreReport() {
    var report = this.props.report;
    this._startLoading();

    $.ajax({
      url: 'games/' + report.game_id + '.json',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: report.home_score,
        away_score: report.away_score
      },
      success: this.reportAccepted
    })
  },

  reportAccepted(response) {
    this._finishLoading();
    this.props.gamesIndex.updateGame(response.game);
  },

  render() {
    var report = this.props.report;
    var btnClasses = classNames('btn', 'btn-success', 'btn-xs', {'is-loading': this.state.isLoading});

    return (
      <tr>
        <td className="score">
          {report.score}
        </td>
        <td className="submitted-by">
          {report.submitted_by}
        </td>
        <td className="submitted-at">
          {report.submitted_at}
        </td>
        <td>
          {report.sotg_score}
        </td>
        <td className="comments">
          {report.comments}
        </td>
        <td>
          <button className={btnClasses} onClick={this.acceptScoreReport}>
            Accept
          </button>
        </td>
      </tr>
    );
  }
});

module.exports = GamesIndex;
