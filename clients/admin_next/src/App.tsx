import * as React from 'react';
import TopBar from './Layout/TopBar';

import { withStyles, WithStyles } from '@material-ui/core/styles';
import withTheme from './withTheme';

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

export default withTheme(withStyles(styles)<{}>(App));
