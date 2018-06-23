import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles'
import { NavItems as styles } from '../assets/jss/styles';

import { NavLink } from 'react-router-dom';

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

const primaryItems = [
  { path: "/", icon: faHome, text: "Home" },
  { path: "/teams", icon: faUsers, text: "Teams" },
  { path: "/divisions", icon: faSitemap, text: "Divisions" },
  { path: "/fields", icon: faMapSigns, text: "Fields" },
  { path: "/schedule", icon: faCalendar, text: "Schedule" }
]

const secondaryItems = [
  { path: "/games", icon: faList, text: "Games" }
]

const NavItem = (path: string, icon: any, text: string) => {
  return (
    <NavLink to={path} style={{textDecoration: 'None'}} key={text}>
      <ListItem button>
        <ListItemIcon>
          <FontAwesomeIcon icon={icon} />
        </ListItemIcon>
        <ListItemText primary={text} />
      </ListItem>
    </NavLink>
  )
}

interface Props extends WithStyles<typeof styles> {}

class NavItems extends React.Component<Props> {
  public render() {
    const { classes } = this.props;

    return (
      <div className={classes.list}>
        <List>
          <div>
            {primaryItems.map((item) => {
              return NavItem(item.path, item.icon, item.text)
            })}
          </div>
        </List>

        <Divider/>
        
        <List>
          <div>
            {secondaryItems.map((item) => {
              return NavItem(item.path, item.icon, item.text)
            })}
          </div>
        </List>
      </div>
    )
  }
}

export default withStyles(styles)(NavItems);