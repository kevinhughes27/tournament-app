import * as React from 'react';
import TopBar from './TopBar';

import { withStyles, WithStyles } from '@material-ui/core/styles';
import withRoot from './withRoot';

const styles = {
  root: {
    flexGrow: 1,
  }
};


interface Props extends WithStyles<typeof styles> {}

class App extends React.Component<Props> {
  public render () {
    const { classes } = this.props;

    return (
      <div className={classes.root}>
        <TopBar />
      </div>
    );
  }
}

export default withRoot(withStyles(styles)<{}>(App));
