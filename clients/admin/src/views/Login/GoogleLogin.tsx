import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import { Login as styles } from '../../assets/jss/styles';

import Button from '@material-ui/core/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { library, IconDefinition } from '@fortawesome/fontawesome-svg-core';
import { faGoogle } from '@fortawesome/free-brands-svg-icons';
library.add(faGoogle as IconDefinition);

interface Props extends WithStyles<typeof styles> {}

class GoogleLogin extends React.Component<Props> {
  redirect = () => {
    if (process.env.NODE_ENV === 'development') {
      window.alert(
        'Sign in with Google only works in development when served from Rails. ' +
          'Run `yarn build` and try from the Rails server'
      );
    } else {
      const url = '/auth/google_oauth2';
      window.location.href = url;
    }
  };

  render() {
    const { classes } = this.props;

    return (
      <Button
        className={classes.google}
        variant="contained"
        onClick={this.redirect}
      >
        <FontAwesomeIcon
          icon={['fab', 'google']}
          size="lg"
          style={{ marginRight: 15 }}
        />
        <span style={{ paddingLeft: 15, paddingRight: 15 }}>
          Sign in with Google
        </span>
      </Button>
    );
  }
}

export default withStyles(styles)(GoogleLogin);
