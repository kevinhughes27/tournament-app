import * as React from 'react';
import IconButton from '@material-ui/core/IconButton';
import Avatar from '@material-ui/core/Avatar';
import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';

import { withStyles, WithStyles } from '@material-ui/core/styles';

const styles = {
  flex: {
    flex: 1,
  },
  menuButton: {
    marginLeft: -12,
    marginRight: 20,
  },
};


interface Props extends WithStyles<typeof styles> {}

interface State {
  anchorEl: string | undefined;
};

class UserMenu extends React.Component<Props, State> {
  public state = {
    anchorEl: undefined,
  };

  public handleMenu = (event: any) => {
    this.setState({ anchorEl: event.currentTarget });
  };

  public handleClose = () => {
    this.setState({ anchorEl: undefined });
  };

  public render () {
    const { anchorEl } = this.state;
    const open = Boolean(anchorEl);

    return (
        <div>
            <IconButton
            onClick={this.handleMenu}
            color="inherit"
            >
            <Avatar alt="Kevin Hughes" src="https://www.gravatar.com/avatar/a14e0880b9ef8720734a7db6b6c4ade0" />
            </IconButton>
            <Menu
            id="menu-appbar"
            anchorEl={anchorEl}
            anchorOrigin={{
                vertical: 'top',
                horizontal: 'right',
            }}
            transformOrigin={{
                vertical: 'top',
                horizontal: 'right',
            }}
            open={open}
            onClose={this.handleClose}
            >
            <MenuItem onClick={this.handleClose}>Profile</MenuItem>
            <MenuItem onClick={this.handleClose}>My account</MenuItem>
            </Menu>
        </div>
    );
  }
}

export default withStyles(styles)<{}>(UserMenu);
