import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { query } from "../../queries/TeamShowQuery";
import renderQuery from "../../helpers/renderQuery";
import TeamShow from "./TeamShow";

interface Props extends RouteComponentProps<any> {}

class TeamShowContainer extends React.Component<Props> {
  render() {
    const teamId = this.props.match.params.teamId;
    return renderQuery(query, {teamId}, TeamShow);
  }
}

export default withRouter(TeamShowContainer);
