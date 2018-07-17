import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core";
import { Warning as styles } from "../../assets/jss/styles";
import SnackbarContent from "@material-ui/core/SnackbarContent";
import WarningIcon from "@material-ui/icons/Warning";

interface Props  extends WithStyles<typeof styles> {
  message?: string;
}

class Warning extends React.Component<Props> {
  render() {
    const { message, classes } = this.props;

    if (message === undefined) {
      return null;
    }

    return (
      <SnackbarContent
        className={classes.warning}
        message={<span className={classes.message}>
          <WarningIcon className={classes.icon}/>
          <span>{this.props.message}</span>
        </span>}
      />
    );
  }
}

export default withStyles(styles)(Warning);
