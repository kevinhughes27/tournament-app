import * as React from "react";
import Gravatar from 'react-gravatar';
import { withRouter, RouteComponentProps } from "react-router-dom";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { UserMenu as styles } from "../../assets/jss/styles";

import IconButton from "@material-ui/core/IconButton";
import Avatar from "@material-ui/core/Avatar";
import Menu from "@material-ui/core/Menu";
import MenuItem from "@material-ui/core/MenuItem";

import auth from "../../auth";

type Props = RouteComponentProps<{}> & WithStyles<typeof styles> & {};

interface State {
  open: boolean;
  anchorEl: any;
}

class UserMenu extends React.Component<Props, State> {
  state = {
    open: false,
    anchorEl: undefined
  };

  handleOpen = (event: any) => {
    this.setState({ open: true, anchorEl: event.currentTarget });
  }

  handleClose = () => {
    this.setState({ open: false, anchorEl: undefined });
  }

  handleLogout = () => {
    auth.logout();
    this.props.history.push("/");
  }

  render() {
    const { viewer } = this.props;
    const { open, anchorEl } = this.state;
    const email = viewer && viewer.email
    console.log('1111',email)

    return (
      <div>
        <IconButton onClick={this.handleOpen}>
          <Gravatar email={email} />
        </IconButton>
        <Menu
          id="user-menu"
          anchorEl={anchorEl}
          anchorOrigin={{vertical: "top", horizontal: "right"}}
          transformOrigin={{vertical: "top", horizontal: "right"}}
          open={open}
          onClose={this.handleClose}
        >
          <MenuItem onClick={this.handleClose}>Profile</MenuItem>
          <MenuItem onClick={this.handleClose}>Settings</MenuItem>
          <MenuItem onClick={this.handleLogout}>Logout</MenuItem>
        </Menu>
      </div>
    );
  }
}

export default withRouter(withStyles(styles)(UserMenu));
