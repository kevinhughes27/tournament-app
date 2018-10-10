import * as React from "react";
import { FormButtons as styles } from "../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";
import TrashIcon from "@material-ui/icons/Delete";
import CircularProgress from "@material-ui/core/CircularProgress";

interface Props extends WithStyles<typeof styles> {
  onClick?: () => void;
  disabled: boolean;
  deleting: boolean;
}

class DeleteButton extends React.Component<Props> {
  render() {
    const { disabled, deleting, classes } = this.props;

    return (
      <Button
        variant="contained"
        color="secondary"
        onClick={this.props.onClick}
        className={classes.deleteButton}
        classes={{disabled: classes.disabled}}
        disabled={disabled || deleting}
      >
        {this.buttonContent()}
      </Button>
    );
  }

  buttonContent = () => {
    const { deleting } = this.props;

    if (deleting) {
      return <CircularProgress size={20} />;
    } else {
      return <TrashIcon />;
    }
  }
}

export default withStyles(styles)(DeleteButton);
