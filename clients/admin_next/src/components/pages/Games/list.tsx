import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  games: any;
}

const Row = (g: any) => (
  <TableRow key={g.id}>
    <TableCell>{g.id}</TableCell>
    <TableCell>{g.homeName} vs {g.awayName}</TableCell>
    <TableCell>{g.homeScore} - {g.awayScore}</TableCell>
  </TableRow>
);

class GamesList extends React.Component<Props> {
  render() {
    const { games } = this.props;

    return (
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>ID</TableCell>
            <TableCell>Name</TableCell>
            <TableCell>Score</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {games.map(Row)}
        </TableBody>
      </Table>
    );
  }
}

export default withStyles(styles)(GamesList);
