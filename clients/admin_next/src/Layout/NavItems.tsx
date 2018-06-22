import * as React from 'react';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';

import GroupIcon from '@material-ui/icons/Group';
import DivisionsIcon from '@material-ui/icons/GridOn';
import PlaceIcon from '@material-ui/icons/Place';
import CalendarIcon from '@material-ui/icons/PermContactCalendar';
import GamesIcon from '@material-ui/icons/List';

import Divider from '@material-ui/core/Divider';
import { withStyles, WithStyles } from '@material-ui/core/styles'

const styles = {
  list: {
    width: 250,
  }  
}

interface Props extends WithStyles<typeof styles> {}

class NavItems extends React.Component<Props> {
  public render() {
    const { classes } = this.props;

    return (
      <div className={classes.list}>
        <List>
          <div>
            <ListItem button>
              <ListItemIcon>
                <GroupIcon />
              </ListItemIcon>
              <ListItemText primary="Teams" />
            </ListItem>
            <ListItem button>
              <ListItemIcon>
                <DivisionsIcon />
              </ListItemIcon>
              <ListItemText primary="Divisions" />
            </ListItem>
            <ListItem button>
              <ListItemIcon>
                <PlaceIcon />
              </ListItemIcon>
              <ListItemText primary="Fields" />
            </ListItem>
            <ListItem button>
              <ListItemIcon>
                <CalendarIcon />
              </ListItemIcon>
              <ListItemText primary="Schedule" />
            </ListItem>
          </div>
        </List>
        <Divider/>
        <List>
          <div>
            <ListItem button>
              <ListItemIcon>
                <GamesIcon />
              </ListItemIcon>
              <ListItemText primary="Games" />
            </ListItem>
          </div>
        </List>
      </div>
    )
  }
}

export default withStyles(styles)(NavItems);