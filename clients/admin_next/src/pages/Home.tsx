import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { BlankSlate as styles } from "../assets/jss/styles";

interface Props extends WithStyles<typeof styles> {}

class Home extends React.Component<Props> {
  public render() {
    const { classes } = this.props;

    return (
      <div className={classes.container}>
        <span className={classes.item}>Home</span>
      </div>
    );
  }
}

export default withStyles(styles)(Home);
