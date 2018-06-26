import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  divisions: any;
}

const Row = (d: any) => (
  <TableRow key={d.id}>
    <TableCell>{d.id}</TableCell>
    <TableCell>{d.name}</TableCell>
    <TableCell>{d.bracketType}</TableCell>
  </TableRow>
);

class DivisionsList extends React.Component<Props> {
  render() {
    const { divisions } = this.props;

    return (
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>ID</TableCell>
            <TableCell>Name</TableCell>
            <TableCell>BracketType</TableCell>
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
