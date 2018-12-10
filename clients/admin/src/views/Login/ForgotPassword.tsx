import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import { Login as styles } from '../../assets/jss/styles';

interface Props extends WithStyles<typeof styles> {}

class ForgotPassword extends React.Component<Props> {
  handleClick = (event: React.MouseEvent<HTMLAnchorElement>) => {
    if (process.env.NODE_ENV === 'development') {
      event.preventDefault();
      window.alert(
        'Sign in with Google only works in development when served from Rails. ' +
          'Run `yarn build` and try from the Rails server'
      );
    }
  };

  render() {
    const { classes } = this.props;

    return (
      <a
        href="/password/new"
        onClick={this.handleClick}
        className={classes.forgotLink}
      >
        Forgot your password?
      </a>
    );
  }
}

export default withStyles(styles)(ForgotPassword);
