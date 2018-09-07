import * as React from "react";
import * as Gravatar from "react-gravatar";
import {createFragmentContainer, graphql} from "react-relay";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { UserMenu as styles } from "../../assets/jss/styles";
import IconButton from "@material-ui/core/IconButton";
import Menu from "@material-ui/core/Menu";
import MenuItem from "@material-ui/core/MenuItem";
import auth from "../../auth";

type Props = RouteComponentProps<{}> & WithStyles<typeof styles> & {
  viewer: UserMenu_viewer;
};

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

export default createFragmentContainer(withRouter(withStyles(styles)(UserMenu)), {
  viewer: graphql`
    fragment UserMenu_viewer on User {
      id
      name
      email
    }
  `
});
