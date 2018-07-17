import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

import Breadcrumbs from "../../components/Breadcrumbs";
import GameListItem from "./GameListItem";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  games: Game[];
}

class GameList extends React.Component<Props> {
  render() {
    const { games } = this.props;

    return (
      <div>
        <Breadcrumbs items={[{text: "Games"}]} />
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
            {games.map((g: Game) => <GameListItem key={g.id} game={g}/>)}
          </TableBody>
        </Table>
      </div>
    );
  }
}

const StyledGameList = withStyles(styles)(GameList);

export default createFragmentContainer(StyledGameList, {
  games: graphql`
    fragment GameList_games on Game @relay(plural: true) {
      id
      ...GameListItem_game
    }
  `
});
