import * as React from 'react';
import Paper from '@material-ui/core/Paper';
import Typography from '@material-ui/core/Typography';
import SpiritScore from './SpiritScore';

interface Props {
  report: GameListQuery_games_scoreReports;
}

class ScoreReport extends React.Component<Props> {
  render() {
    const report = this.props.report;
    const comments = report.comments && `"${report.comments}"`;

    return (
      <div className="score-report">
        <div>
          <Paper className="score-card">
            {report.homeScore}-{report.awayScore}
          </Paper>
          <SpiritScore report={report} />
        </div>
        <div>
          <Typography variant="subtitle2">{comments}</Typography>
          <Typography variant="caption">{`Submitted by: ${
            report.submittedBy
          }`}</Typography>
          <Typography variant="caption">{`Device ID: ${
            report.submitterFingerprint
          }`}</Typography>
        </div>
      </div>
    );
  }
}

export default ScoreReport;
