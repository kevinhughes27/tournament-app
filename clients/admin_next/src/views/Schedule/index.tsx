import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import ScheduleEditor from "./ScheduleEditor";

const query = graphql`
  query ScheduleQuery {
    fields {
      ...ScheduleEditor_fields
    }
    games {
      ...ScheduleEditor_games
    }
  }
`;

class Schedule extends React.Component {
  render() {
    return renderQuery(query, {}, ScheduleEditor);
  }
}

export default Schedule;
