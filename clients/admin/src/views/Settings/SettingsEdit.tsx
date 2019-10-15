import * as React from 'react';
import SettingsForm from './SettingsForm';
import AddUserModal from './AddUserModal';
import { Typography, WithStyles, withStyles, List, ListItem } from '@material-ui/core';

const styles = {
  heading: {
    paddingTop: 10,
    paddingLeft: 20
  },
  adminList: {
    paddingLeft: 5
  }
}

interface Props extends WithStyles<typeof styles> {
  settings: SettingsQuery_settings;
}

class SettingsEdit extends React.Component<Props> {
  render() {
    const { classes, settings } = this.props;

    const input = {
      name: settings.name,
      handle: settings.handle,
      timezone: settings.timezone,
      scoreSubmitPin: settings.scoreSubmitPin,
      gameConfirmSetting: settings.gameConfirmSetting
    };

    return (
      <>
        <SettingsForm input={input} />
        <Typography variant="h6" component="h2" className={classes.heading}>
          Admins:
        </Typography>
        <List dense className={classes.adminList}>
          {settings.admins.map((admin) => { return (
            <ListItem key={admin}>{admin}</ListItem>
          )})}
        </List>
        <AddUserModal />
      </>
    );
  }
}

export default withStyles(styles)(SettingsEdit);
