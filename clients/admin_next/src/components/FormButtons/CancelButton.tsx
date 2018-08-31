import * as React from "react";
import { FormButtons as styles } from "../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";

interface Props extends WithStyles<typeof styles> {
  onClick?: () => void;
  disabled: boolean;
}

class CancelButton extends React.Component<Props> {
  render() {
    const { disabled, classes } = this.props;

    return (
      <Button
        variant="contained"
        color="secondary"
        onClick={this.props.onClick}
        className={classes.cancelButton}
        classes={{disabled: classes.disabled}}
        disabled={disabled}
      >
        Cancel
      </Button>
    );
  }
}

export default withStyles(styles)(CancelButton);
