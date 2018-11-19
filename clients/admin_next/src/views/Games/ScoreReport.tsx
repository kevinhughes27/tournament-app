import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Paper from "@material-ui/core/Paper";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemText from "@material-ui/core/ListItemText";
import ListItemSecondaryAction from "@material-ui/core/ListItemSecondaryAction";
import Rating from "react-star-rating-lite";
import Tooltip from "@material-ui/core/Tooltip";
import Button from "@material-ui/core/Button";
import { sum } from "lodash";

interface Props {
  report: ScoreReport_report;
}

class ScoreReport extends React.Component<Props> {
  render() {
    const report = this.props.report;
    const comments = report.comments && `"${report.comments}"`
    const submittedBy = `Submitted by: ${report.submittedBy} ${report.submitterFingerprint}`
    const avgSpirit = sum([
      report.fairness,
      report.fouls,
      report.attitude,
       report.rulesKnowledge,
      report.communication
    ]) / 5.0;

    return(
      <ListItem>
        <ListItemIcon>
          <Paper className="score-card">
            {report.homeScore}-{report.awayScore}
          </Paper>
        </ListItemIcon>
        <ListItemText primary={comments} secondary={submittedBy} />
        <ListItemSecondaryAction>
          <div style={{paddingTop: 5}}>
            <Tooltip
              placement="top-start"
              disableFocusListener
              title={
                <div style={{fontSize: 14}}>
                  <strong>Spirit Score:</strong>
                  <ul style={{listStyleType: "none", padding: 0, margin: 0}}>
                    <li>Rules Knowledge: {report.rulesKnowledge}</li>
                    <li>Fouls: {report.fouls}</li>
                    <li>Fairness: {report.fairness}</li>
                    <li>Attitude: {report.attitude}</li>
                    <li>Communication: {report.communication}</li>
                  </ul>
                </div>
              }
            >
              <Button>
                <Rating value={avgSpirit} weight="14" readonly />
              </Button>
            </Tooltip>
          </div>
        </ListItemSecondaryAction>
      </ListItem>
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
      rulesKnowledge
      fouls
      fairness
      attitude
      communication
      comments
    }
  `
});
