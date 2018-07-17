import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  games: Game[];
}

const Row = (g: any) => (
  <TableRow key={g.id}>
    <TableCell>{g.homeName} vs {g.awayName}</TableCell>
    <TableCell>{g.division.name}</TableCell>
    <TableCell>{g.pool}</TableCell>
    <TableCell>{g.homeScore} - {g.awayScore}</TableCell>
  </TableRow>
);

class GameList extends React.Component<Props> {
  render() {
    const { games } = this.props;

    return (
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Division</TableCell>
            <TableCell>Pool</TableCell>
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

const StyledGameList = withStyles(styles)(GameList);

export default createFragmentContainer(StyledGameList, {
  games: graphql`
    fragment GameList_games on Game @relay(plural: true) {
      id
      pool
      homeName
      awayName
      homeScore
      awayScore
      division {
        id
        name
      }
    }
  `
});
