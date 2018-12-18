import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import { Login as styles } from '../../assets/jss/styles';

import Button from '@material-ui/core/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { library, IconDefinition } from '@fortawesome/fontawesome-svg-core';
import { faFacebookF } from '@fortawesome/free-brands-svg-icons';
library.add(faFacebookF as IconDefinition);

interface Props extends WithStyles<typeof styles> {}

class FacebookLogin extends React.Component<Props> {
  redirect = () => {
    if (process.env.NODE_ENV === 'development') {
      window.alert(
        'Sign in with Facebook only works in development when served from Rails. ' +
          'Run `yarn build` and try from the Rails server'
      );
    } else {
      const url = '/auth/facebook';
      window.location.href = url;
    }
  };

  render() {
    const { classes } = this.props;

    return (
      <Button
        className={classes.facebook}
        variant="contained"
        onClick={this.redirect}
      >
        <FontAwesomeIcon
          icon={['fab', 'facebook-f']}
          size="lg"
          style={{ marginRight: 15 }}
        />
        <span style={{ paddingLeft: 15, paddingRight: 15 }}>
          Sign in with Facebook
        </span>
      </Button>
    );
  }
}

export default withStyles(styles)(FacebookLogin);
