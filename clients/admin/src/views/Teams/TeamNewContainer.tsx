import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import TeamNew from "./TeamNew";

class TeamNewContainer extends React.Component {
  render() {
    const query = gql`
      query TeamNewQuery {
        divisions {
          id
          name
        }
      }
    `;

    return renderQuery(query, {}, TeamNew);
  }
}

export default TeamNewContainer;
