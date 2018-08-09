import * as React from "react";
import { SubmitButton as styles } from "../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Zoom from "@material-ui/core/Zoom";
import Button from "@material-ui/core/Button";
import SaveIcon from "@material-ui/icons/Save";
import CircularProgress from "@material-ui/core/CircularProgress";

interface Props extends WithStyles<typeof styles> {
  inline?: boolean;
  icon?: JSX.Element;
  disabled: boolean;
  submitting: boolean;
}

class SubmitButton extends React.Component<Props> {
  render() {
    const { inline, disabled, submitting, classes, theme } = this.props;

    const transitionDuration = {
      enter: theme!.transitions.duration.enteringScreen,
      exit: theme!.transitions.duration.leavingScreen,
    };

    return (
      <Zoom
        in={true}
        timeout={transitionDuration}
        style={{transitionDelay: `${transitionDuration.exit}ms`}}
        unmountOnExit
      >
        <Button
          variant="contained"
          color="primary"
          type="submit"
          className={inline ? classes.inline : classes.fab}
          disabled={disabled || submitting}
        >
          {this.buttonContent()}
        </Button>
      </Zoom>
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

export default withStyles(styles, {withTheme: true})(SubmitButton);
