import * as React from "react";
import Notice from "../Notice";
import SideBar from "./SideBar";
import TopBar from "./TopBar";
import Routes from "../../views/routes";

interface State {
  navOpen: boolean;
}

class Admin extends React.Component<{}, State> {
  state = {
    navOpen: false,
  };

  openNav = () => {
    this.setState({navOpen: true});
  }

  closeNave = () => {
    this.setState({navOpen: false});
  }

  render() {
    return (
      <div>
        <TopBar openNav={this.openNav} />
        <SideBar
          open={this.state.navOpen}
          handleOpen={this.openNav}
          handleClose={this.closeNave}
        />
        <Notice/>
        <Routes/>
      </div>
    );
  }
}

export default Admin;
