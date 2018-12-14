import * as React from 'react';

import { DragDropContext } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';

import ActionMenu from '../../components/ActionMenu';
import DownloadIcon from '@material-ui/icons/CloudDownload';
import BlankSlate from '../../components/BlankSlate';
import Calendar from './Calendar';
import Unscheduled from './Unscheduled';
import Legend from './Legend';

interface Props {
  fields: ScheduleEditorQuery['fields'];
  games: ScheduleEditorQuery['games'];
}

class ScheduleEditor extends React.Component<Props> {
  handleDownload = () => {
    const url = '/schedule.pdf';
    window.open(url);
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
          <h3>Create the Schedule for Your Tournament</h3>
          <p>You need to create Fields before you can build your schedule.</p>
        </BlankSlate>
      );
    } else if (games.length === 0) {
      return (
        <BlankSlate>
          <h3>Create the Schedule for Your Tournament</h3>
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
          <ActionMenu
            actions={[
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
