import * as React from 'react';
import { withRouter, RouteComponentProps } from 'react-router-dom';

import LoginForm from './LoginForm';
import auth from '../../modules/auth';

interface Props extends RouteComponentProps<any> {}

class Login extends React.Component<Props> {
  handleLogin = () => {
    this.props.history.push(this.props.location);
  };

  render() {
    const component = auth.loggedIn() ? (
      this.props.children
    ) : (
      <LoginForm onComplete={this.handleLogin} />
    );

    return component;
  }
}

export default withRouter(Login);
