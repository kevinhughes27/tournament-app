var _ = require("underscore");
var $ = require("jquery");

var CollapsibleMixin = require('react-collapsible-mixin');

var GameIndex = React.createClass({
  getInitialState() {
    return { searchString: '' };
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

  render() {
    var games = this.props.games;
    var searchString = this.state.searchString;

    if(searchString) {
      games = this.searchFilter(games, searchString);
    };

    return (
      <section className="content">
        <div className="box">
          <div className="box-body">
            <div className="input-group" style={{paddingBottom: '15px'}}>
              <div className="input-group-addon">
                <i className="fa fa-search"></i>
              </div>
              <input className="search form-control"
                     value={searchString}
                     placeholder="Search"
                     onChange={this.searchUpdated}/>
            </div>
            <GameTable games={games}/>
          </div>
        </div>
      </section>
    );
  }
});

var GameTable = React.createClass({
  getInitialState() {
    return {
      sortBy: '',
      sortReverse: false
    };
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

  render() {
    var games = this.props.games;
    var sortBy = this.state.sortBy;
    var sortReverse = this.state.sortReverse;

    if(sortBy) {
      games = this.sortFilter(games, sortBy, sortReverse);
    }

    return (
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
          { games.map(function(game) {
            return <Game {...game} />;
          })}
        </tbody>
      </table>
    );
  }
});

var Game = React.createClass({
  mixins: [CollapsibleMixin],

  render() {
    var game = this.props;
    var collapseId = "reports" + game.id;

    var nameRow;
    if (game.score_reports.length > 0) {
      nameRow = <a href={"#" + collapseId} className={collapseId} onClick={this._onToggleCollapsible}>
        {game.name + " "}
        <span className="badge"> {game.score_reports.length} </span>
      </a>
    } else {
      nameRow = game.name;
    }

    var confirmIcon;
    if(game.confirmed) {
      confirmIcon = <i className="fa fa-check" style={{color: 'green'}}></i>;
    } else {
      confirmIcon = <i className="fa fa-exclamation-circle" style={{color: 'orange'}}></i>;
    }

    return (
      <tr>
        <td className="col-md-7 table-link name">
          {nameRow}
          <div ref={collapseId} className={this.getCollapsibleClassSet(collapseId)}>
            <ScoreReports reports={game.score_reports}/>
          </div>
        </td>
        <td className="col-md-2 division">
          {game.division}
        </td>
        <td className="col-md-1 table-link score">
          {game.score}
        </td>
        <td className="col-md-2">
          {confirmIcon}
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
              { reports.map(function(report) {
                return <ScoreReport {...report} />;
              })}
            </tbody>
          </table>
        </div>
      </div>
    );
  }
});

var ScoreReport = React.createClass({
  acceptScoreReport() {
    var report = this.props;

    $.ajax({
      url: 'games/' + report.game_id + '.json',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: report.home_score,
        away_score: report.away_score
      },
      success: function(response){
        debugger;
      }
    })
  },

  render() {
    var report = this.props;

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
          <a className="btn btn-success btn-xs" onClick={this.acceptScoreReport}>
            Accept
          </a>
        </td>
      </tr>
    );
  }
});

module.exports = GameIndex;
