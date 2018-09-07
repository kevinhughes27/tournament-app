import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Admin as styles } from "../../assets/jss/styles";
import Notice from "../Notice";
import SideBar from "./SideBar";
import TopBar from "./TopBar";
import Routes from "../../views/routes";

interface Props extends WithStyles<typeof styles> {}

interface State {
  navOpen: boolean;
}

class Admin extends React.Component<Props, State> {
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
    const {classes} = this.props;

    return (
      <div className={classes.root}>
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

export default withStyles(styles)(Admin);
