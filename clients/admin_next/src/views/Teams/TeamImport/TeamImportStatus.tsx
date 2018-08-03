import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import LinearProgress from "@material-ui/core/LinearProgress";
import TeamImporter from "./TeamImporter";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  importer: TeamImporter;
}

class TeamImportStatus extends React.Component<Props> {
  constructor(props: Props) {
    super(props);
    this.props.importer.setTick(() => this.forceUpdate());
  }

  render() {
    const { importer } = this.props;

    return (
      <div>
        <LinearProgress variant="determinate" value={importer.progress()} />
        {JSON.stringify(importer.errors)}
      </div>
    );
  }
}

export default withStyles(styles)(TeamImportStatus);
