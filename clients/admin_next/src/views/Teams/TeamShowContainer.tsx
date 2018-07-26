import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import TeamShow from "./TeamShow";

interface Props extends RouteComponentProps<any> {}

class TeamShowContainer extends React.Component<Props> {
  render() {
    const teamId = this.props.match.params.teamId;

    const query = graphql`
      query TeamShowContainerQuery($teamId: ID!) {
        team(id: $teamId) {
          ...TeamShow_team
        }
        divisions {
          ...DivisionPicker_divisions
        }
      }
    `;

    return renderQuery(query, {teamId}, TeamShow);
  }
}

export default withRouter(TeamShowContainer);
