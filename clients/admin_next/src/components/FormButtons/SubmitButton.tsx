import * as React from "react";
import { FormButtons as styles } from "../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";
import SaveIcon from "@material-ui/icons/Save";
import CircularProgress from "@material-ui/core/CircularProgress";

interface Props extends WithStyles<typeof styles> {
  icon?: JSX.Element;
  onClick?: () => void;
  disabled: boolean;
  submitting: boolean;
}

class SubmitButton extends React.Component<Props> {
  render() {
    const { disabled, submitting, classes } = this.props;

    return (
      <Button
        variant="contained"
        color="primary"
        type="submit"
        onClick={this.props.onClick}
        classes={{disabled: classes.disabled}}
        disabled={disabled || submitting}
      >
        {this.buttonContent()}
      </Button>
    );
  }

  buttonContent = () => {
    const { submitting, icon } = this.props;

    if (submitting) {
      return <CircularProgress size={20} />;
    } else if (icon) {
      return icon;
    } else {
      return <SaveIcon />;
    }
  }
}

export default withStyles(styles)(SubmitButton);
