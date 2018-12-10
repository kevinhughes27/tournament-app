import * as React from 'react';
import SettingsForm from './SettingsForm';

interface Props {
  settings: SettingsQuery_settings;
}

class SettingsEdit extends React.Component<Props> {
  render() {
    const { settings } = this.props;

    const input = {
      name: settings.name,
      handle: settings.handle,
      timezone: settings.timezone,
      scoreSubmitPin: settings.scoreSubmitPin,
      gameConfirmSetting: settings.gameConfirmSetting
    };

    return <SettingsForm input={input} />;
  }
}

export default SettingsEdit;
