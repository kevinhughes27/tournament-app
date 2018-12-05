import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import Checklist from "./Checklist";

const query = gql`
  query HomeQuery {
    fields {
      id
    }
    teams {
      id
    }
    divisions {
      id
      numTeams
      isSeeded
    }
    games {
      id
      scheduled
      endTime
      scoreConfirmed
    }
    scoreDisputes {
      id
    }
  }
`;

class Home extends React.Component {
  render() {
    return renderQuery(query, {}, Checklist);
  }
}

export default Home;
