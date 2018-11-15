import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderQuery";
import TeamList from "./TeamList";

const query = graphql`
  query TeamListContainerQuery {
    teams {
      ...TeamList_teams
    },
    divisions {
      ...TeamList_divisions
    }
  }
`;

class TeamListContainer extends React.Component {
  render() {
    return renderQuery(query, {}, TeamList);
  }
}

export default TeamListContainer;
