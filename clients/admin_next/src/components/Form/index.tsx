import * as React from "react";

import Toast from "./Toast";
import Warning from "./Warning";

interface FormAPI {
  reset: () => void;
  showMessage: (message: string) => void;
  showError: (error: string) => void;
}

interface State {
  message?: string;
  error?: string;
}

const defaultState = {
  message: undefined,
  error: undefined
};

const Form = <Props extends FormAPI>(WrappedForm: React.ComponentType<Props>) =>
  class extends React.Component<Props & FormAPI, State> {
    state = defaultState;

    reset = () => {
      this.setState(defaultState);
    }

    showError = (error?: string) => {
      this.setState({error});
    }

    showMessage = (message: string) => {
      this.setState({message});
    }

    render() {
      return (
        <div style={{padding: 20}}>
          <Toast message={this.state.message} />
          <Warning error={this.state.error} />
          <WrappedForm
            {...this.props}
            reset={this.reset}
            showMessage={this.showMessage}
            showError={this.showError}
          />
        </div>
      );
    }
  };

export {
  Form,
  FormAPI
};
