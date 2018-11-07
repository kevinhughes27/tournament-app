import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import BlankSlate from "../../components/BlankSlate";

import Breadcrumbs from "../../components/Breadcrumbs";
import GameListItem from "./GameListItem";

interface Props {
  games: GameList_games;
}

class GameList extends React.Component<Props> {
  renderContent = () => {
    const { games } = this.props;

    if (games.length > 0) {
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
              {games.map((g) => <GameListItem key={g.id} game={g}/>)}
            </TableBody>
          </Table>
        </div>
      );
    } else {
      return (
        <BlankSlate>
          <h3>Games and Score Reports</h3>
          <p>
            After Divisions are created your games will be found here.
            Review and accept submitted scores from this page.
          </p>
        </BlankSlate>
      );
    }
  }

  render() {
    return this.renderContent();
  }
}

export default createFragmentContainer(GameList, {
  games: graphql`
    fragment GameList_games on Game @relay(plural: true) {
      id
      ...GameListItem_game
    }
  `
});
