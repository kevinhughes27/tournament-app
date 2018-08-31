import * as React from "react";
import { FormButtons as styles } from "../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Zoom from "@material-ui/core/Zoom";
import SubmitButton from "./SubmitButton";
import DeleteButton from "./DeleteButton";
import CancelButton from "./CancelButton";

interface Props extends WithStyles<typeof styles> {
  inline?: boolean;
  submitIcon?: JSX.Element;
  submitDisabled: boolean;
  submitting: boolean;
  submit?: () => void;
}

class FormButtons extends React.Component<Props> {
  render() {
    const { inline, classes, theme } = this.props;

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
        <div className={inline ? classes.inline : classes.fab}>
          <CancelButton
            disabled={false}
          />
          <DeleteButton
            disabled={false}
            submitting={false}
          />
          <SubmitButton
            icon={this.props.submitIcon}
            disabled={this.props.submitDisabled}
            submitting={this.props.submitting}
            onClick={this.props.submit}
          />
        </div>
      </Zoom>
    );
  }
}

export default withStyles(styles, {withTheme: true})(FormButtons);
