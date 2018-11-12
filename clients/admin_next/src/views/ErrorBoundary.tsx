import * as React from "react";
import BlankSlate from "../components/BlankSlate";

declare var Rollbar: any;

class ErrorBoundary extends React.Component {
  state = {
    hasError: false
  }

  componentDidCatch(error: Error) {
    debugger
    this.setState({ hasError: true });
    Rollbar.error(error);
  }

  renderError = () => (
    <BlankSlate>
      <h3>Ooops! something went wrong.</h3>
      <p>We've been notified and are working on a fix.</p>
    </BlankSlate>
  )

  render() {
    if(this.state.hasError) {
      return this.renderError();
    } else {
      return this.props.children;
    }
  }
}

export default ErrorBoundary;
