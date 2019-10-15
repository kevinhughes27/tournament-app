import * as React from 'react';
import { withRouter, RouteComponentProps, NavLink } from 'react-router-dom';
import IconButton from '@material-ui/core/IconButton';
import Avatar from '@material-ui/core/Avatar';
import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import gravatarUrl from 'gravatar-url';
import auth from '../modules/auth';

interface Props extends RouteComponentProps<{}> {
  viewer: UserMenuQuery['viewer'];
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
  };

  handleClose = () => {
    this.setState({ open: false, anchorEl: undefined });
  };

  handleLogout = () => {
    auth.logout();
    this.props.history.push('/');
  };

  render() {
    const { open, anchorEl } = this.state;
    const email = (this.props.viewer && this.props.viewer.email) || '';
    const avatarUrl = gravatarUrl(email, { size: 50 });

    return (
      <div id="user-menu">
        <IconButton onClick={this.handleOpen}>
          <Avatar alt={email} src={avatarUrl} />
        </IconButton>
        <Menu
          anchorEl={anchorEl}
          anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
          transformOrigin={{ vertical: 'top', horizontal: 'right' }}
          open={open}
          onClose={this.handleClose}
        >
          <MenuItem>
            <NavLink
              to="/user"
              onClick={this.handleClose}
              style={{ textDecoration: 'none', color: '#000000de' }}
            >
              Profile
            </NavLink>
          </MenuItem>
          <MenuItem>
            <NavLink
              to="/settings"
              onClick={this.handleClose}
              style={{ textDecoration: 'none', color: '#000000de' }}
            >
              Settings
            </NavLink>
          </MenuItem>
          <MenuItem onClick={this.handleLogout}>Logout</MenuItem>
        </Menu>
      </div>
    );
  }
}

export default withRouter(UserMenu);
