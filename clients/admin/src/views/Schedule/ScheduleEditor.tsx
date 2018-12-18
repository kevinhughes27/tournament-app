import * as React from 'react';

import { DragDropContext } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';

import ActionMenu from '../../components/ActionMenu';
import DownloadIcon from '@material-ui/icons/CloudDownload';
import SettingsIcon from '@material-ui/icons/Settings';
import BlankSlate from '../../components/BlankSlate';
import Calendar from './Calendar';
import Unscheduled from './Unscheduled';
import Legend from './Legend';
import SettingsModal from './SettingsModal';

interface Props {
  fields: ScheduleEditorQuery['fields'];
  games: ScheduleEditorQuery['games'];
}

class ScheduleEditor extends React.Component<Props> {
  state = {
    settingsOpen: false
  };

  handleDownload = () => {
    const url = '/schedule.pdf';
    window.open(url);
  };

  openSettings = () => {
    this.setState({ settingsOpen: true });
  };

  closeSettings = () => {
    this.setState({ settingsOpen: false });
  };

  render() {
    const { fields, games } = this.props;
    const scheduledGames = games.filter(g => !!g.startTime) as ScheduledGame[];
    const unscheduledGames = games.filter(
      g => !g.startTime
    ) as UnscheduledGame[];

    if (fields.length === 0) {
      return (
        <BlankSlate>
          <h3>Create the Schedule for your Tournament</h3>
          <p>You need to create Fields before you can build your schedule.</p>
        </BlankSlate>
      );
    } else if (games.length === 0) {
      return (
        <BlankSlate>
          <h3>Create the Schedule for your Tournament</h3>
          <p>
            After you create Divisions you'll be able to make your schedule on
            this page.
          </p>
        </BlankSlate>
      );
    } else {
      return (
        <>
          {this.renderTop(unscheduledGames)}
          <hr />
          <Calendar games={scheduledGames} fields={fields} />
          <SettingsModal
            open={this.state.settingsOpen}
            handleClose={this.closeSettings}
            onUpdate={() => this.forceUpdate()}
          />
          <ActionMenu
            actions={[
              {
                icon: <SettingsIcon />,
                name: 'Settings',
                handler: this.openSettings
              },
              {
                icon: <DownloadIcon />,
                name: 'Download PDF',
                handler: this.handleDownload
              }
            ]}
          />
        </>
      );
    }
  }

  renderTop = (unscheduledGames: UnscheduledGame[]) => {
    if (unscheduledGames.length === 0) {
      return <Legend games={unscheduledGames} />;
    } else {
      return <Unscheduled games={unscheduledGames} />;
    }
  };
}

export default DragDropContext(HTML5Backend)(ScheduleEditor);
