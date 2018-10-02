import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import SettingsForm from "./SettingsForm";

interface Props {
  settings: SettingsEdit_settings;
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

    return (
      <SettingsForm input={input} />
    );
  }
}

export default createFragmentContainer(SettingsEdit, {
  settings: graphql`
    fragment SettingsEdit_settings on Settings {
      name
      handle
      timezone
      scoreSubmitPin
      gameConfirmSetting
    }
  `
});
