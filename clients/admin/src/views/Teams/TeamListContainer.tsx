import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import TeamList from "./TeamList";

const query = gql`
  query TeamListQuery {
    teams {
      id
      name
      email
      division {
        id
        name
      }
      seed
    },
    divisions {
      id
      name
    }
  }
`;

class TeamListContainer extends React.Component {
  render() {
    return renderQuery(query, {}, TeamList);
  }
}

export default TeamListContainer;
