import * as React from "react";
import { FormButtons as styles } from "../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Zoom from "@material-ui/core/Zoom";
import SubmitButton from "./SubmitButton";
import DeleteButton from "./DeleteButton";
import CancelButton from "./CancelButton";

interface Props extends WithStyles<typeof styles, true> {
  inline?: boolean;
  submitIcon?: JSX.Element;
  formValid?: boolean;
  formDirty?: boolean;
  submitting: boolean;
  submit?: () => void;
  delete?: () => void;
  cancel?: () => void;
  cancelLink?: string;
}

interface State {
  deleting: boolean;
}

class FormButtons extends React.Component<Props> {
  static defaultProps = {
    inline: false,
    formDirty: true,
    formValid: true
  };

  state = {
    deleting: false
  };

  delete = async () => {
    this.setState({deleting: true});
    await this.props.delete();
    this.setState({deleting: false});
  }

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
          {this.renderCancelButton()}
          {this.renderDeleteButton()}
          {this.renderSubmitButton()}
        </div>
      </Zoom>
    );
  }

  renderCancelButton = () => {
    if (this.props.cancel || this.props.cancelLink) {
      return (
        <CancelButton
          disabled={this.props.submitting || this.state.deleting}
          onClick={this.props.cancel}
          link={this.props.cancelLink}
        />
      );
    } else {
      return null;
    }
  }

  renderDeleteButton = () => {
    if (this.props.delete) {
      return (
        <DeleteButton
          disabled={this.props.submitting || this.state.deleting}
          deleting={this.state.deleting}
          onClick={this.delete}
        />
      );
    } else {
      return null;
    }
  }

  renderSubmitButton = () => (
    <SubmitButton
      icon={this.props.submitIcon}
      disabled={!this.props.formDirty || !this.props.formValid || this.state.deleting}
      submitting={this.props.submitting}
      onClick={this.props.submit}
    />
  )
}

export default withStyles(styles, {withTheme: true})(FormButtons);
