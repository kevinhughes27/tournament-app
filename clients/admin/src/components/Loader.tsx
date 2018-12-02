import * as React from "react";
import CircularProgress from "@material-ui/core/CircularProgress";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Loader as styles } from "../assets/jss/styles";

interface Props extends WithStyles<typeof styles> {}

class Loader extends React.Component<Props> {
  render() {
    const { classes } = this.props;

    return (
      <div className={classes.container}>
        <CircularProgress className={classes.spinner} color="secondary" size={50} />
      </div>
    );
  }
}

export default withStyles(styles)(Loader);
