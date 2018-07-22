import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core";
import { ErrorBanner as styles } from "../assets/jss/styles";
import SnackbarContent from "@material-ui/core/SnackbarContent";
import WarningIcon from "@material-ui/icons/Warning";

let showErrorsFn: (message: string) => void;
let hideErrorsFn: () => void;

interface Props  extends WithStyles<typeof styles> {}

interface State {
  show: boolean;
  message: string;
}

class Warning extends React.Component<Props, State> {
  state = {
    show: false,
    message: ""
  };

  componentDidMount() {
    showErrorsFn = this.handleShow;
    hideErrorsFn = this.handleHide;
  }

  handleShow = (message: string) => {
    this.setState({
      show: true,
      message
    });
  }

  handleHide = () => {
    this.setState({
      show: false,
      message: "",
    });
  }

  render() {
    const { classes } = this.props;
    const { show, message } = this.state;

    if (show) {
      return (
        <SnackbarContent
          className={classes.warning}
          message={<span className={classes.message}>
            <WarningIcon className={classes.icon}/>
            <span>{message}</span>
          </span>}
        />
      );
    } else {
      return null;
    }
  }
}

export function showErrors(message: string) {
  showErrorsFn(message);
}

export function hideErrors() {
  hideErrorsFn();
}

export default withStyles(styles)(Warning);
