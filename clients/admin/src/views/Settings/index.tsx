import * as React from 'react';
import { query } from '../../queries/SettingsQuery';
import renderQuery from '../../helpers/renderQuery';
import SettingsEdit from './SettingsEdit';

class Settings extends React.Component {
  render() {
    return renderQuery(query, {}, SettingsEdit);
  }
}

export default Settings;
