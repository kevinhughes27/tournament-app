import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  teams: any;
}

const Row = (t: any) => (
  <TableRow key={t.id}>
    <TableCell>{t.name}</TableCell>
    <TableCell>{t.division.name}</TableCell>
    <TableCell>{t.seed}</TableCell>
  </TableRow>
);

class TeamsList extends React.Component<Props> {
  render() {
    const { teams } = this.props;

    return (
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Division</TableCell>
            <TableCell>Seed</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {teams.map(Row)}
        </TableBody>
      </Table>
    );
  }
}

export default withStyles(styles)(TeamsList);
