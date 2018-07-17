import * as React from "react";

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
            {teams.map((t: any) => <TeamListItem key={t.id} team={t}/>)}
          </TableBody>
        </Table>
      </div>
    );
  }
}

export default withStyles(styles)(TeamList);
