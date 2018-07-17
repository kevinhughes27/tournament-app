import * as React from "react";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

import TeamList from "./TeamList";

const query = graphql`
  query TeamListContainerQuery {
    teams {
      ...TeamList_teams
    }
  }
`;

class TeamListContainer extends React.Component {
  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{}}
        render={render(TeamList)}
      />
    );
  }
}

export default TeamListContainer;
