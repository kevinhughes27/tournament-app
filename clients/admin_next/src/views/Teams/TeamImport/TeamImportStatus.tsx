import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import LinearProgress from "@material-ui/core/LinearProgress";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  progress: number;
  errors: any;
}

class TeamImportStatus extends React.Component<Props> {
  render() {
    const { progress, errors } = this.props;

    return (
      <div>
        <LinearProgress variant="determinate" value={progress} />
        {JSON.stringify(errors)}
      </div>
    );
  }
}

export default withStyles(styles)(TeamImportStatus);
