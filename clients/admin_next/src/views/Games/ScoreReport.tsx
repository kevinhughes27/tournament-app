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
    const submittedBy = `Submitted by: ${report.submittedBy} ${report.submitterFingerprint}`

    return(
      <div className="score-report">
        <Paper className="score-card">
          {report.homeScore}-{report.awayScore}
        </Paper>
        <div style={{flexBasis: "60%"}}>
          <Typography variant="subtitle2">{comments}</Typography>
          <Typography variant="caption">{submittedBy}</Typography>
        </div>
        <SpiritScore report={report} />
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
