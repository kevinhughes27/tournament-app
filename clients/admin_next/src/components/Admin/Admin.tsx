import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Admin as styles } from "../../assets/jss/styles";
import TopBar from "./TopBar";
import SideBar from "./SideBar";
import UserMenu from "./UserMenu";
import Notice from "../Notice";
import Routes from "../../views/routes";

interface State {
  navOpen: boolean;
}

interface Props extends WithStyles<typeof styles> {
  viewer: UserMenu_viewer;
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
    const { classes } = this.props; 
      return(
        <div className={classes.root}>
          <TopBar
            openNav={this.openNav}
            viewer={this.props.viewer}
          />
          <SideBar
            open={this.state.navOpen}
            handleOpen={this.openNav}
            handleClose={this.closeNave}
          />
          <Notice />
          <Routes/>
        </div>
       );   
  }
}

export default withStyles(styles)(Admin);