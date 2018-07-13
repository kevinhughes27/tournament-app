import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core";
import { Errors as styles } from "../assets/jss/styles";
import SnackbarContent from "@material-ui/core/SnackbarContent";
import WarningIcon from "@material-ui/icons/Warning";

interface Props  extends WithStyles<typeof styles> {
  errors?: string[];
}

class Errors extends React.Component<Props> {
  render() {
    const { errors, classes } = this.props;

    if (errors === undefined || errors.length === 0) {
      return null;
    }

    return (
      <SnackbarContent
        className={classes.warning}
        message={<span className={classes.message}>
          <WarningIcon className={classes.icon}/>
          {renderErrors(errors)}
        </span>}
      />
    );
  }
}

const renderErrors = (errors: string[]) => {
  if (errors.length > 1) {
    return (
      <ul>
        {errors.map((e: string) => <li key={e}>{e}</li>)}
      </ul>
    );
  } else {
    return errors[0];
  }
};

export default withStyles(styles)(Errors);
