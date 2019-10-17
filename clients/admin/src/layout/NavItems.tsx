import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles';

import { NavLink } from 'react-router-dom';

import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import Divider from '@material-ui/core/Divider';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faHome,
  faUsers,
  faSitemap,
  faMapSigns,
  faCalendar,
  faList,
  faMobile,
  faCogs
} from '@fortawesome/free-solid-svg-icons';

interface Props extends WithStyles<typeof styles> {}

const styles = {
  list: {
    width: 250
  },
  bottom: {
    position: "absolute" as "absolute",
    bottom: 0
  }
};

const primaryItems = [
  { path: '/', icon: faHome, text: 'Home' },
  { path: '/teams', icon: faUsers, text: 'Teams' },
  { path: '/divisions', icon: faSitemap, text: 'Divisions' },
  { path: '/fields', icon: faMapSigns, text: 'Fields' },
  { path: '/schedule', icon: faCalendar, text: 'Schedule' }
];

const secondaryItems = [
  { path: '/games', icon: faList, text: 'Games' },
  { path: '/app', icon: faMobile, text: 'App' }
];

const bottomItems = [
  { path: '/settings', icon: faCogs, text: 'Settings' },
];

const NavItem = (path: string, icon: any, text: string) => (
  <NavLink to={path} style={{ color: 'black', textDecoration: 'None' }} key={text}>
    <ListItem button>
      <ListItemIcon>
        <FontAwesomeIcon icon={icon} />
      </ListItemIcon>
      <ListItemText primary={text} />
    </ListItem>
  </NavLink>
);

const NavItems = (props: Props) => {
  const { classes } = props;

  return (
    <div className={classes.list}>
      <List>
        {primaryItems.map(item => NavItem(item.path, item.icon, item.text))}
      </List>

      <Divider />

      <List>
        {secondaryItems.map(item => NavItem(item.path, item.icon, item.text))}
      </List>

      <List className={classes.bottom}>
        {bottomItems.map(item => NavItem(item.path, item.icon, item.text))}
      </List>
    </div>
  );
};

export default withStyles(styles)(NavItems);
