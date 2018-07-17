import * as React from "react";
import { Subtract } from "utility-types";

import Notice from "./Notice";
import Warning from "./Warning";

interface FormAPI {
  reset: () => void;
  showMessage: (message: string) => void;
  showError: (errorMessage: string) => void;
}

interface State {
  message?: string;
  errorMessage?: string;
}

const defaultState = {
  message: undefined,
  errorMessage: undefined
};

const Form = <Props extends FormAPI>(WrappedForm: React.ComponentType<Props>) =>
  class extends React.Component<Subtract<Props, FormAPI>, State> {
    state = defaultState;

    reset = () => {
      this.setState(defaultState);
    }

    showError = (errorMessage?: string) => {
      this.setState({errorMessage});
    }

    showMessage = (message: string) => {
      this.setState({message});
    }

    render() {
      return (
        <div style={{padding: 20}}>
          <Notice message={this.state.message} />
          <Warning message={this.state.errorMessage} />
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
