import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import LinearProgress from "@material-ui/core/LinearProgress";
import ImportErrors from "./ImportErrors";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  progress: number;
  errors: {
    [key: number]: string;
  };
}

class ImportStatus extends React.Component<Props> {
  render() {
    const { progress, errors } = this.props;

    return (
      <>
        <LinearProgress variant="determinate" value={progress} />
        <ImportErrors errors={errors} />
      </>
    );
  }
}

export default withStyles(styles)(ImportStatus);
