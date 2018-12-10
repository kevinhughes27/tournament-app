import * as React from 'react';
import Modal from './Modal';
import FormButtons from './FormButtons';

let showConfirmFn: (
  message: string,
  confirm: () => void,
  cancel: () => void
) => void;

interface State {
  open: boolean;
  message: string;
  confirm: () => void;
  cancel: () => void;
}

class Confirm extends React.Component<{}, State> {
  state = {
    open: false,
    message: '',
    confirm: () => null,
    cancel: () => null
  };

  componentDidMount() {
    showConfirmFn = this.handleOpen;
  }

  handleOpen = (message: string, confirm: () => void, cancel: () => void) => {
    if (message) {
      this.setState({
        open: true,
        message,
        confirm,
        cancel
      });
    }
  };

  handleClose = () => {
    this.state.cancel();

    this.setState({
      open: false,
      message: '',
      confirm: () => null,
      cancel: () => null
    });
  };

  submit = () => {
    this.state.confirm();
    this.handleClose();
  };

  render() {
    return (
      <Modal
        title="Confirmation Required"
        open={this.state.open}
        onClose={this.handleClose}
      >
        <p>{this.state.message}</p>
        <FormButtons
          inline={true}
          submitIcon={<span>Confirm</span>}
          submit={this.submit}
          submitting={false}
          cancel={this.handleClose}
        />
      </Modal>
    );
  }
}

export function showConfirm(
  message: string,
  confirm: () => void,
  cancel: () => void
) {
  showConfirmFn(message, confirm, cancel);
}

export default Confirm;
