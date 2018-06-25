import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { UserMenu as styles } from "../assets/jss/styles";

import IconButton from "@material-ui/core/IconButton";
import Avatar from "@material-ui/core/Avatar";
import Menu from "@material-ui/core/Menu";
import MenuItem from "@material-ui/core/MenuItem";

interface Props extends WithStyles<typeof styles> {}

interface State {
  open: boolean;
}

class UserMenu extends React.Component<Props, State> {
  public state = {
    open: false,
  };

  public handleOpen = () => {
    this.setState({ open: true });
  }

  public handleClose = () => {
    this.setState({ open: false });
  }

  public render() {
    const { open } = this.state;

    return (
      <div>
        <IconButton
          onClick={this.handleOpen}
          color="inherit"
        >
          <Avatar alt="Kevin Hughes" src="https://www.gravatar.com/avatar/a14e0880b9ef8720734a7db6b6c4ade0" />
        </IconButton>
        <Menu
          id="menu-appbar"
          anchorOrigin={{vertical: "top", horizontal: "right"}}
          transformOrigin={{vertical: "top", horizontal: "right"}}
          open={open}
          onClose={this.handleClose}
        >
          <MenuItem onClick={this.handleClose}>Profile</MenuItem>
          <MenuItem onClick={this.handleClose}>Settings</MenuItem>
          <MenuItem onClick={this.handleClose}>Logout</MenuItem>
        </Menu>
      </div>
    );
  }
}

export default withStyles(styles)(UserMenu);
