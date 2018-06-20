import * as React from 'react';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import UserMenu from './UserMenu';

import { withStyles, WithStyles } from '@material-ui/core/styles';
import withRoot from './withRoot';

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

class TopBar extends React.Component<Props> {
  public render () {
    const { classes } = this.props;

    return (
        <AppBar position="static">
            <Toolbar>
                <IconButton className={classes.menuButton} color="inherit" aria-label="Menu">
                    <MenuIcon />
                </IconButton>
                <Typography variant="title" color="inherit" className={classes.flex}>
                    Ultimate Tournament
                </Typography>
                <UserMenu />
            </Toolbar>
        </AppBar>
    );
  }
}

export default withRoot(withStyles(styles)<{}>(TopBar));
