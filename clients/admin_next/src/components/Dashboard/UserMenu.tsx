import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import { withRouter, RouteComponentProps, NavLink } from "react-router-dom";
import IconButton from "@material-ui/core/IconButton";
import Avatar from "@material-ui/core/Avatar";
import Menu from "@material-ui/core/Menu";
import MenuItem from "@material-ui/core/MenuItem";
import gravatarUrl from "gravatar-url";
import auth from "../../helpers/auth";

interface Props extends RouteComponentProps<{}> {
  viewer: UserMenu_viewer;
}

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
    const { open, anchorEl } = this.state;
    const email = this.props.viewer && this.props.viewer.email;
    const avatarUrl = gravatarUrl(email, {size: 50});

    return (
      <div>
        <IconButton onClick={this.handleOpen}>
        <Avatar alt={email} src={avatarUrl} />
        </IconButton>
        <Menu
          id="user-menu"
          anchorEl={anchorEl}
          anchorOrigin={{vertical: "top", horizontal: "right"}}
          transformOrigin={{vertical: "top", horizontal: "right"}}
          open={open}
          onClose={this.handleClose}
        >
          <MenuItem>
            <NavLink to="/user">Profile</NavLink>
          </MenuItem>
          <MenuItem onClick={this.handleClose}>Settings</MenuItem>
          <MenuItem onClick={this.handleLogout}>Logout</MenuItem>
        </Menu>
      </div>
    );
  }
}

export default createFragmentContainer(withRouter(UserMenu), {
  viewer: graphql`
    fragment UserMenu_viewer on User {
      id
      name
      email
    }
  `
});
