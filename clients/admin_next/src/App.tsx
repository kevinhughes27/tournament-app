import * as React from 'react';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import Avatar from '@material-ui/core/Avatar';

import { withStyles, WithStyles } from '@material-ui/core/styles';
import withRoot from './withRoot';

const styles = {
  root: {
    flexGrow: 1,
  },
  flex: {
    flex: 1,
  },
  avatar: {
    margin: 10,
  },
  menuButton: {
    marginLeft: -12,
    marginRight: 20,
  },
};


interface Props extends WithStyles<typeof styles> {}

function App(props: Props) {
  const { classes } = props;
  return (
    <div className={classes.root}>
      <AppBar position="static">
        <Toolbar>
          <IconButton className={classes.menuButton} color="inherit" aria-label="Menu">
            <MenuIcon />
          </IconButton>
          <Typography variant="title" color="inherit" className={classes.flex}>
            Ultimate Tournament
          </Typography>
          <Avatar alt="Kevin Hughes" src="https://www.gravatar.com/avatar/a14e0880b9ef8720734a7db6b6c4ade0" className={classes.avatar} />
          Kevin Hughes
        </Toolbar>
      </AppBar>
    </div>
  );
}

export default withRoot(withStyles(styles)<{}>(App));
