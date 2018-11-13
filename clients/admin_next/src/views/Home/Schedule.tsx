import * as React from "react";
import LinearProgress from "@material-ui/core/LinearProgress";

interface Props {
  games: number;
  scheduled: number;
}

class Schedule extends React.Component<Props> {
  render() {
    const progress = this.props.scheduled / this.props.games * 100;

    return (
      <div>
        <p>
          Assign games to fields and times with the schedule editor.
        </p>
        <LinearProgress variant="determinate" value={progress} />
        <p style={{marginTop: 15}}>{this.props.scheduled} / {this.props.games} scheduled</p>
      </div>
    )
  }
}

export default Schedule;
