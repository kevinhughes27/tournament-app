import React from 'react'
import {Tooltip, OverlayTrigger} from 'react-bootstrap'
import classNames from 'classnames'

class ScoreReports extends React.Component {
  render () {
    let reports = this.props.reports

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
              </tr>
            </thead>
            <tbody>
              { reports.map((report, idx) => {
                return <ScoreReport key={idx} report={report} />
              })}
            </tbody>
          </table>
        </div>
      </div>
    )
  }
}

class ScoreReport extends React.Component {
  tooltip (report) {
    return (
      <Tooltip id={`report${report.id}submitter`}
        placement="top">{report.submitter_fingerprint}
      </Tooltip>
    )
  }

  render () {
    let report = this.props.report

    return (
      <tr className={ classNames({warning: report.sotg_warning}) }>
        <td className="score">
          {report.score}
        </td>
        <td className="submitted-by">
          <OverlayTrigger overlay={this.tooltip(report)} delayShow={300} delayHide={150}>
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
      </tr>
    )
  }
}

module.exports = ScoreReports
