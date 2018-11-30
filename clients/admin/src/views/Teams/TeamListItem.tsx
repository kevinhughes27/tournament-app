import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";
import TableCell from "@material-ui/core/TableCell";
import TableRow from "@material-ui/core/TableRow";
import { decodeId } from "../../helpers/relay";

interface Props extends RouteComponentProps<any> {
  team: TeamListItem_team;
}

class TeamListItem extends React.Component<Props> {
  handleClick = () => {
    const teamId = decodeId(this.props.team.id);
    this.props.history.push(`/teams/${teamId}`);
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
