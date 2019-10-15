import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import UserMenuContainer from './UserMenuContainer';

interface Props extends WithStyles<typeof styles> {
  openNav: (event: React.SyntheticEvent<{}>) => void;
}

const styles = {
  title: {
    flex: 1,
    color: 'white'
  },
  menuButton: {
    color: 'white',
    marginLeft: -12,
    marginRight: 20
  }
};

class TopBar extends React.Component<Props> {
  render() {
    const { classes } = this.props;

    return (
      <AppBar position="static">
        <Toolbar>
          <IconButton
            id="side-bar"
            className={classes.menuButton}
            onClick={this.props.openNav}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" className={classes.title}>
            Ultimate Tournament
          </Typography>
          <UserMenuContainer />
        </Toolbar>
      </AppBar>
    );
  }
}

export default withStyles(styles)(TopBar);
