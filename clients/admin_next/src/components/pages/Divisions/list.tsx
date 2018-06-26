import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import TeamsCell from "./TeamsCell";
import SeededCell from "./SeededCell";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  divisions: any;
}

const Row = (d: any) => (
  <TableRow key={d.id}>
    <TableCell>{d.name}</TableCell>
    <TableCell>{d.bracketType}</TableCell>
    <TableCell>{TeamsCell(d)}</TableCell>
    <TableCell>{SeededCell(d)}</TableCell>
  </TableRow>
);

class DivisionsList extends React.Component<Props> {
  render() {
    const { divisions } = this.props;

    return (
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Bracket</TableCell>
            <TableCell>Teams</TableCell>
            <TableCell>Seeded</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {divisions.map(Row)}
        </TableBody>
      </Table>
    );
  }
}

export default withStyles(styles)(DivisionsList);
