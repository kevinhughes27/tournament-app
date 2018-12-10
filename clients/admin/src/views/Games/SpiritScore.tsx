import * as React from 'react';
import ReactStars from 'react-stars';
import Tooltip from '@material-ui/core/Tooltip';
import Typography from '@material-ui/core/Typography';
import { sum } from 'lodash';

interface Props {
  report: GameListQuery_games_scoreReports;
}

class SpiritScore extends React.Component<Props> {
  render() {
    const report = this.props.report;

    const avgSpirit =
      sum([
        report.fairness,
        report.fouls,
        report.attitude,
        report.rulesKnowledge,
        report.communication
      ]) / 5.0;

    return (
      <div className="spirit-score">
        <Tooltip
          placement="right-end"
          disableFocusListener
          title={
            <div style={{ fontSize: 16, lineHeight: 1.2 }}>
              <strong>Spirit Score:</strong>
              <ul style={{ listStyleType: 'none', padding: 0, margin: 0 }}>
                <li>Rules Knowledge: {report.rulesKnowledge}</li>
                <li>Fouls: {report.fouls}</li>
                <li>Fairness: {report.fairness}</li>
                <li>Attitude: {report.attitude}</li>
                <li>Communication: {report.communication}</li>
              </ul>
            </div>
          }
        >
          <div>
            <Typography variant="caption">Spirit score</Typography>
            <ReactStars value={avgSpirit} count={4} size={18} edit={false} />
          </div>
        </Tooltip>
      </div>
    );
  }
}

export default SpiritScore;
