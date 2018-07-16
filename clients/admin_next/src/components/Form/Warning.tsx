import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core";
import { Warning as styles } from "../../assets/jss/styles";
import SnackbarContent from "@material-ui/core/SnackbarContent";
import WarningIcon from "@material-ui/icons/Warning";

interface Props  extends WithStyles<typeof styles> {
  error?: string;
}

class Warning extends React.Component<Props> {
  render() {
    const { error, classes } = this.props;

    if (error === undefined) {
      return null;
    }

    return (
      <SnackbarContent
        className={classes.warning}
        message={<span className={classes.message}>
          <WarningIcon className={classes.icon}/>
          <span>{this.props.error}</span>
        </span>}
      />
    );
  }
}

export default withStyles(styles)(Warning);
