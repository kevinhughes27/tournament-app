import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import SettingsForm from "./SettingsForm";

interface Props {
  settings: Settings_settings;
}

class Settings extends React.Component<Props> {
  render() {
    const { settings } = this.props;

    const input = {
      name: settings.name,
      handle: settings.handle,
      timezone: settings.timezone,
      protectScoreSubmit: settings.protectScoreSubmit,
      gameConfirmSetting: settings.gameConfirmSetting
    };

    return (
       <div className="user_info">
        <div className="col-md-6 col-md-offset-3">
           <SettingsForm input={input} />
        </div>
      </div>
    );
  }
}

export default createFragmentContainer(Settings, {
  settings: graphql`
    fragment Settings_settings on Settings {
      name
      handle
      timezone
      protectScoreSubmit
      gameConfirmSetting
    }
  `
});
