var React = require('react'),
    ReactDOM = require('react-dom'),
    Tooltip = require('react-bootstrap').Tooltip,
    OverlayTrigger = require('react-bootstrap').OverlayTrigger,
    classNames = require('classnames'),
    confirm = require('./confirm'),
    LoadingMixin = require('../mixins/loading_mixin');

var ScoreReports = React.createClass({
  render() {
    var reports = this.props.reports;

    return (
      <div style={{paddingTop: 25}}>
        <div className="panel panel-default" style={{minWidth: 320}}>
          <div className="panel-heading">Score Reports</div>
          <table className="table table-striped table-hover">
            <thead>
              <tr>
                <th>Score</th>
                <th>Submitted by</th>
                <th className="hidden-xs">Submitted at</th>
                <th className="hidden-xs">SOTG</th>
                <th className="hidden-xs">Comments</th>
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

  submit() {
    this.acceptScoreReport();
  },

  acceptScoreReport(force = false) {
    var report = this.props.report;
    this._startLoading();

    $.ajax({
      url: 'games/' + report.game_id,
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: report.home_score,
        away_score: report.away_score,
        force: force
      },
      success: (response) => {
        this._finishLoading();
        Admin.Flash.notice('Score report accepted');
      },
      error: (response) => {
        this._finishLoading();

        if(response.status == 422) {
          this.confirmAcceptScore();
        } else {
          Admin.Flash.error('Error accepting score report');
        }
      }
    });
  },

  confirmAcceptScore() {
    confirm({
      title: "Confirm Accept Score",
      message: "This update will change the teams in games that come after it\
      and some of those games have been scored. If you update this\
      score those games will be reset. This cannot be undone."
    }).then(
      (result) => {
        this.acceptScoreReport(true);
      },
      (result) => {
        console.log('cancelled');
      }
    );
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
        <td className="submitted-at hidden-xs">
          {report.submitted_at}
        </td>
        <td className="hidden-xs">
          {report.sotg_score}
        </td>
        <td className="comments hidden-xs">
          {report.comments}
        </td>
        <td>
          <button className={btnClasses} onClick={this.submit}>
            Accept
          </button>
        </td>
      </tr>
    );
  }
});

module.exports = ScoreReports;
