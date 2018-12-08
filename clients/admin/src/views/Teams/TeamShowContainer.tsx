import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import TeamShow from "./TeamShow";

export const query = gql`
  query TeamShowQuery($teamId: ID!) {
    team(id: $teamId) {
      id
      name
      email
      division {
        id
        name
      }
      seed
    }
    divisions {
      id
      name
    }
  }
`;

interface Props extends RouteComponentProps<any> {}

class TeamShowContainer extends React.Component<Props> {
  render() {
    const teamId = this.props.match.params.teamId;
    return renderQuery(query, {teamId}, TeamShow);
  }
}

export default withRouter(TeamShowContainer);
