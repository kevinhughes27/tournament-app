import * as React from 'react';
import TopBar from './TopBar';
import SideBar from './SideBar';
import Notice from '../Notice';
import Confirm from '../Confirm';

interface State {
  navOpen: boolean;
}

class Admin extends React.Component<{}, State> {
  state = {
    navOpen: false
  };

  openNav = () => {
    this.setState({ navOpen: true });
  };

  closeNave = () => {
    this.setState({ navOpen: false });
  };

  render() {
    return (
      <>
        <TopBar openNav={this.openNav} />
        <SideBar
          open={this.state.navOpen}
          handleOpen={this.openNav}
          handleClose={this.closeNave}
        />
        <Confirm />
        <Notice />
      </>
    );
  }
}

export default Admin;
