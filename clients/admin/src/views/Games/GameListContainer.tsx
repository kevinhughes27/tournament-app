import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import GameList from "./GameList";

export const query = gql`
  query GameListQuery {
    games {
      id
      division {
        id
        name
      }
      pool
      startTime
      endTime
      hasTeams
      homeName
      awayName
      homeScore
      awayScore
      scoreReports {
        id
        id
        submittedBy
        submitterFingerprint
        homeScore
        awayScore
        rulesKnowledge
        fouls
        fairness
        attitude
        communication
        comments
      }
      scoreConfirmed
      scoreDisputed
    }
  }
`;

class GameListContainer extends React.Component {
  render() {
    return renderQuery(query, {}, GameList);
  }
}

export default GameListContainer;
