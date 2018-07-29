import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import { DragDropContext } from "react-dnd";
import HTML5Backend from "react-dnd-html5-backend";

import Calendar from "./Calendar";
import Unscheduled from "./Unscheduled";
import Legend from "./Legend";

interface Props {
  fields: ScheduleEditor_fields;
  games: ScheduleEditor_games;
}

class ScheduleEditor extends React.Component<Props> {
  render() {
    const { fields, games } = this.props;
    const unscheduledGames = games.filter((g) => !g.startTime) as UnscheduledGame[];
    const scheduledGames = games.filter((g) => !!g.startTime) as ScheduledGame[];

    return (
      <div>
        {this.renderTop(unscheduledGames)}
        <hr/>
        <Calendar games={scheduledGames} fields={fields}/>
      </div>
    );
  }

  renderTop = (unscheduledGames: UnscheduledGame[]) => {
    if (unscheduledGames.length === 0) {
      return <Legend games={unscheduledGames} />;
    } else {
      return <Unscheduled games={unscheduledGames}/>;
    }
  }
}

export default createFragmentContainer(
  DragDropContext(HTML5Backend)(ScheduleEditor), {
    fields: graphql`
      fragment ScheduleEditor_fields on Field @relay(plural: true) {
        id
        name
      }
    `,
    games: graphql`
      fragment ScheduleEditor_games on Game @relay(plural: true) {
        id
        homePrereq
        awayPrereq
        homePoolSeed
        awayPoolSeed
        pool
        bracketUid
        round
        startTime
        endTime
        field {
          id
          name
        }
        division {
          id
          name
        }
      }
    `
  }
);
