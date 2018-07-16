import * as React from "react";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Form as styles } from "../../assets/jss/styles";

import Toast from "./Toast";
import Warning from "./Warning";

interface Props extends WithStyles<typeof styles> {
  message?: string;
  error?: string;
}

class Form extends React.Component<Props> {
  render() {
    const { classes } = this.props;

    return (
      <div className={classes.container}>
        <Toast message={this.props.message} />
        <Warning error={this.props.error} />
        {this.props.children}
      </div>
    );
  }
}

export default withStyles(styles)(Form);
