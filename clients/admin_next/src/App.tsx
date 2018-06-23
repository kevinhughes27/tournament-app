import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import { App as styles } from './assets/jss/styles';
import withTheme from './withTheme';

import TopBar from './layout/TopBar';
import SideBar from './layout/SideBar';

import { BrowserRouter as Router } from 'react-router-dom';
import Routes from './Routes';

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
      <Router>
        <div className={classes.root}>
          <TopBar openNav={this.openNav} />
          <SideBar 
            open={this.state.navOpen}
            handleOpen={this.openNav}
            handleClose={this.closeNave}
          />
          <Routes />
        </div>
      </Router>
    );
  }
}

export default withTheme(withStyles(styles)(App));
