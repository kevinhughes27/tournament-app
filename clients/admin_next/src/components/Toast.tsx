import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core";
import Snackbar from "@material-ui/core/Snackbar";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";

const styles = {};

interface Props  extends WithStyles<typeof styles> {
  message?: string;
}

interface State {
  open: boolean;
  message: string;
}

class Toast extends React.Component<Props, State> {
  state = {
    open: false,
    message: ""
  };

  componentWillReceiveProps(props: Props) {
    this.setState({
      open: props.message !== undefined,
      message: props.message || ""
    });
  }

  handleClose = () => {
    this.setState({open: false});
  }

  render() {
    return (
      <Snackbar
        anchorOrigin={{vertical: "bottom", horizontal: "left"}}
        open={this.state.open}
        autoHideDuration={1500}
        onClose={this.handleClose}
        ContentProps={{"aria-describedby": "message-id"}}
        message={<span id="message-id">{this.state.message}</span>}
        action={[
          <IconButton
            key="close"
            aria-label="Close"
            color="inherit"
            onClick={this.handleClose}
          >
            <CloseIcon />
          </IconButton>
        ]}
      />
    );
  }
}

export default withStyles(styles)(Toast);
