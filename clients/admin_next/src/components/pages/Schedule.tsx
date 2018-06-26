import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { BlankSlate as styles } from "../../assets/jss/styles";

interface Props extends WithStyles<typeof styles> {}

class Schedule extends React.Component<Props> {
  render() {
    const { classes } = this.props;

    return (
      <div className={classes.container}>
        <span>Schedule</span>
      </div>
    );
  }
}

export default withStyles(styles)(Schedule);
