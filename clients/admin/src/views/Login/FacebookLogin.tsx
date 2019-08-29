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
  submit = (ev: React.FormEvent) => {
    if (process.env.NODE_ENV === 'development') {
      ev.preventDefault();

      window.alert(
        'Sign in with Facebook only works in development when served from Rails. ' +
          'Run `yarn build` and try from the Rails server'
      );
    }
  };

  csrf_token_field = () => {
    const metaNodes = document.getElementsByTagName('meta');
    const name = (metaNodes as any)['csrf-param'].content;
    const token = (metaNodes as any)['csrf-token'].content;

    return <input type="hidden" name={name} value={token} />;
  };

  render() {
    const { classes } = this.props;

    return (
      <form action="/auth/google_oauth2" method="post" onSubmit={this.submit}>
        {this.csrf_token_field()}
        <Button type="submit" variant="contained" className={classes.facebook}>
          <FontAwesomeIcon
            icon={['fab', 'facebook-f']}
            size="lg"
            style={{ marginRight: 15 }}
          />
          <span style={{ paddingLeft: 15, paddingRight: 15 }}>
            Sign in with Facebook
          </span>
        </Button>
      </form>
    );
  }
}

export default withStyles(styles)(FacebookLogin);
