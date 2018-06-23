import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles'
import { NavItems as styles } from '../assets/jss/styles';

import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import Divider from '@material-ui/core/Divider';

import { 
  faHome,
  faUsers,
  faSitemap,
  faMapSigns,
  faCalendar,
  faList
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

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
                <FontAwesomeIcon icon={faHome} />
              </ListItemIcon>
              <ListItemText primary="Home" />
            </ListItem>
            <ListItem button>
              <ListItemIcon>
                <FontAwesomeIcon icon={faUsers} />
              </ListItemIcon>
              <ListItemText primary="Teams" />
            </ListItem>
            <ListItem button>
              <ListItemIcon>
                <FontAwesomeIcon icon={faSitemap} />
              </ListItemIcon>
              <ListItemText primary="Division" />
            </ListItem>
            <ListItem button>
              <ListItemIcon>
              <FontAwesomeIcon icon={faMapSigns} />
              </ListItemIcon>
              <ListItemText primary="Fields" />
            </ListItem>
            <ListItem button>
              <ListItemIcon>
              <FontAwesomeIcon icon={faCalendar} />
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
                <FontAwesomeIcon icon={faList} />
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