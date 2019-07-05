import * as React from 'react';
import BlankSlate from '../components/BlankSlate';
import railsEnv from '../modules/railsEnv';
import rollbar from 'rollbar';

const rollbarConfig = {
  accessToken: 'c4f09f39edb74bc58f2f29bccd539acf',
  captureUncaught: true,
  captureUnhandledRejections: true,
  payload: {
    environment: railsEnv()
  }
};

const Rollbar = rollbar.init(rollbarConfig);

class ErrorBoundary extends React.Component {
  state = {
    hasError: false
  };

  componentDidCatch(error: Error) {
    this.setState({ hasError: true });
    Rollbar.error(error);
  }

  renderError = () => (
    <BlankSlate>
      <h3>Ooops! something went wrong.</h3>
      <p>We've been notified and are working on a fix.</p>
    </BlankSlate>
  );

  render() {
    if (this.state.hasError) {
      return this.renderError();
    } else {
      return this.props.children;
    }
  }
}

export default ErrorBoundary;
