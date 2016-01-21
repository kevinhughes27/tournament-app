var _ = require('underscore'),
    React = require('react'),
    Tooltip = require('react-bootstrap').Tooltip,
    OverlayTrigger = require('react-bootstrap').OverlayTrigger,
    classNames = require('classnames'),
    GamesStore = require('../stores/games_store'),
    LoadingMixin = require('../mixins/loading_mixin');

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
              { reports.map((report, idx) => {
                return <ScoreReport key={idx} report={report} />;
              })}
            </tbody>
          </table>
        </div>
      </div>
    );
  }
});

var ScoreReport = React.createClass({
  mixins: [LoadingMixin],

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
      success: (response) => {
        this._finishLoading();
        var game = response.game;
        game.reportsOpen = true;
        var scroll = window.scrollY;
        GamesStore.updateGame(game);
        window.scrollTo(0, scroll);
        Admin.Flash.notice('Score report accepted');
      },
      error: (response) => {
        this._finishLoading();
        Admin.Flash.error('Error accepting score report');
      }
    });
  },

  render() {
    var report = this.props.report;
    var btnClasses = classNames('btn', 'btn-success', 'btn-xs', {'is-loading': this.state.isLoading});
    var tooltip = <Tooltip id={"report#{report.id}submitter"} placement="top">{report.submitter_fingerprint}</Tooltip>;

    return (
      <tr className={ classNames({warning: report.sotg_warning}) }>
        <td className="score">
          {report.score}
        </td>
        <td className="submitted-by">
          <OverlayTrigger overlay={tooltip} delayShow={300} delayHide={150}>
            <span>{report.submitted_by}</span>
          </OverlayTrigger>
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

module.exports = ScoreReports;
