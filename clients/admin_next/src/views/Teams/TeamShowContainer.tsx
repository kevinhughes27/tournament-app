import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

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

    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{teamId}}
        render={render(TeamShow)}
      />
    );
  }
}

export default withRouter(TeamShowContainer);
