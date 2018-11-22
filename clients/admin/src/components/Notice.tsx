import * as React from "react";
import Snackbar from "@material-ui/core/Snackbar";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";

let showNoticeFn: (message: string) => void;

interface State {
  open: boolean;
  message: string;
}

class Notice extends React.Component<{}, State> {
  state = {
    open: false,
    message: "",
  };

  componentDidMount() {
    showNoticeFn = this.handleOpen;
  }

  handleOpen = (message: string) => {
    if (message) {
      this.setState({
        open: true,
        message,
      });
    }
  }

  handleClose = () => {
    this.setState({
      open: false,
      message: "",
    });
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

export function showNotice(message: string) {
  showNoticeFn(message);
}

export default Notice;
