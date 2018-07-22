import * as React from "react";
import { Subtract } from "utility-types";

import Warning from "./Warning";

interface FormAPI {
  reset: () => void;
  showError: (errorMessage: string) => void;
}

interface State {
  errorMessage?: string;
}

const defaultState = {
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

    render() {
      return (
        <div style={{padding: 20}}>
          <Warning message={this.state.errorMessage} />
          <WrappedForm
            {...this.props}
            reset={this.reset}
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
