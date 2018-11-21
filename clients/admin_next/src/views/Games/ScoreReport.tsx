import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Paper from "@material-ui/core/Paper";
import Typography from "@material-ui/core/Typography";
import SpiritScore from "./SpiritScore";

interface Props {
  report: ScoreReport_report;
}

class ScoreReport extends React.Component<Props> {
  render() {
    const report = this.props.report;
    const comments = report.comments && `"${report.comments}"`

    return(
      <div className="score-report">
        <div>
          <Paper className="score-card">
            {report.homeScore}-{report.awayScore}
          </Paper>
          <SpiritScore report={report} />
        </div>
        <div>
          <Typography variant="subtitle2">{comments}</Typography>
          <Typography variant="caption">{`Submitted by: ${report.submittedBy}`}</Typography>
          <Typography variant="caption">{`Device ID: ${report.submitterFingerprint}`}</Typography>
        </div>
      </div>
    )
  }
}

export default createFragmentContainer(ScoreReport, {
  report: graphql`
    fragment ScoreReport_report on ScoreReport {
      id
      submittedBy
      submitterFingerprint
      homeScore
      awayScore
      comments
      ...SpiritScore_report
    }
  `
});
