import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import ScheduleEditor from "./ScheduleEditor";

export const query = gql`
  query ScheduleEditorQuery {
    fields {
      id
      name
    }
    games {
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
  }
`;

class Schedule extends React.Component {
  render() {
    return renderQuery(query, {}, ScheduleEditor);
  }
}

export default Schedule;
