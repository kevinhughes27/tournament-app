import * as React from "react";
import LinearProgress from "@material-ui/core/LinearProgress";

interface Props {
  divisions: number;
  seeded: number;
}

class Seed extends React.Component<Props> {
  render() {
    const progress = this.props.seeded / this.props.divisions * 100;

    return (
      <div>
        <p>
          Finalize rankings and seed divisions.
        </p>
        <LinearProgress variant="determinate" value={progress} />
        <p style={{marginTop: 15}}>{this.props.seeded} / {this.props.divisions} seeded</p>
      </div>
    )
  }
}

export default Seed;
