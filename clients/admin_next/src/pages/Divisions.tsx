import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { BlankSlate as styles } from "../assets/jss/styles";

interface Props extends WithStyles<typeof styles> {}

class Division extends React.Component<Props> {
  render() {
    const { classes } = this.props;

    return (
      <div className={classes.container}>
        <span className={classes.item}>Division</span>
      </div>
    );
  }
}

export default withStyles(styles)(Division);
