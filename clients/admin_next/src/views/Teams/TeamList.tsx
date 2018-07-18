import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

import Breadcrumbs from "../../components/Breadcrumbs";
import TeamListItem from "./TeamListItem";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  teams: Team[];
}

class TeamList extends React.Component<Props> {
  render() {
    const { teams } = this.props;

    return (
      <div>
        <Breadcrumbs items={[{text: "Teams"}]} />
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Division</TableCell>
              <TableCell>Seed</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {teams.map((t: Team) => <TeamListItem key={t.id} team={t}/>)}
          </TableBody>
        </Table>
      </div>
    );
  }
}

const StyledTeamList = withStyles(styles)(TeamList);

export default createFragmentContainer(StyledTeamList, {
  teams: graphql`
    fragment TeamList_teams on Team @relay(plural: true) {
      id
      ...TeamListItem_team
    }
  `
});
