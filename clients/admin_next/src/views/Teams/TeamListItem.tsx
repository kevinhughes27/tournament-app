import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";

import TableCell from "@material-ui/core/TableCell";
import TableRow from "@material-ui/core/TableRow";

interface Props extends RouteComponentProps<any> {
  team: TeamListItem_team;
}

class TeamListItem extends React.Component<Props> {
  handleClick = () => {
    this.props.history.push(`/teams/${this.props.team.id}`);
  }

  render() {
    const { team } = this.props;

    return (
      <TableRow hover onClick={this.handleClick}>
        <TableCell>{team.name}</TableCell>
        <TableCell>{team.division && team.division.name}</TableCell>
        <TableCell>{team.seed}</TableCell>
      </TableRow>
    );
  }
}

export default createFragmentContainer(withRouter(TeamListItem), {
  team: graphql`
    fragment TeamListItem_team on Team {
      id
      name
      email
      division {
        id
        name
      }
      seed
    }
  `
});
