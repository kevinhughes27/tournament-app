import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import LinearProgress from "@material-ui/core/LinearProgress";
import FieldImportErrors from "./FieldImportErrors";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  progress: number;
  errors: {
    [key: number]: string;
  };
}

class FieldImportStatus extends React.Component<Props> {
  render() {
    const { progress, errors } = this.props;

    return (
      <div>
        <LinearProgress variant="determinate" value={progress} />
        <FieldImportErrors errors={errors} />
      </div>
    );
  }
}

export default withStyles(styles)(FieldImportStatus);
