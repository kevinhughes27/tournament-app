import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import TeamNew from "./TeamNew";

class TeamNewContainer extends React.Component {
  render() {
    const query = graphql`
      query TeamNewContainerQuery {
        divisions {
          ...TeamNew_divisions
        }
      }
    `;

    return renderQuery(query, {}, TeamNew);
  }
}

export default TeamNewContainer;
