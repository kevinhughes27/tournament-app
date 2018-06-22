import * as React from 'react';
import TopBar from './Layout/TopBar';
import SideBar from './Layout/SideBar';

import { withStyles, WithStyles } from '@material-ui/core/styles';
import withTheme from './withTheme';

const styles = {
  root: {
    flexGrow: 1,
  }
};

interface Props extends WithStyles<typeof styles> {}

interface State {
  navOpen: boolean;
};

class App extends React.Component<Props, State> {
  public state = {
    navOpen: false,
  };

  public openNav = () => {
    this.setState({navOpen: true});
  };

  public closeNave = () => {
    this.setState({navOpen: false});
  };

  public render () {
    const { classes } = this.props;

    return (
      <div className={classes.root}>
        <TopBar openNav={this.openNav} />
        <SideBar 
          open={this.state.navOpen}
          handleOpen={this.openNav}
          handleClose={this.closeNave}
        />
      </div>
    );
  }
}

export default withTheme(withStyles(styles)(App));
