import * as React from "react";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

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
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{}}
        render={render(ScheduleEditor)}
      />
    );
  }
}

export default Schedule;
