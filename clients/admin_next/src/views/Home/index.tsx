import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderQuery";
import Checklist from "./Checklist";

const query = graphql`
  query HomeQuery {
    fields {
      ...Checklist_fields
    }
    teams {
      ...Checklist_teams
    }
    divisions {
      ...Checklist_divisions
    }
    games {
      ...Checklist_games
    }
    scoreDisputes {
      ...Checklist_scoreDisputes
    }
  }
`;

class Home extends React.Component {
  render() {
    return renderQuery(query, {}, Checklist);
  }
}

export default Home;
