import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import TableCell from "@material-ui/core/TableCell";
import TableRow from "@material-ui/core/TableRow";
import Badge from "@material-ui/core/Badge";
import Modal from "../../components/Modal";
import ScoreForm from "./ScoreForm";
import ScoreReport from "./ScoreReport";

interface Props {
  game: GameListItem_game;
}

class GameListItem extends React.Component<Props> {
  state = {
    open: false
  };

  handleClick = () => {
    if (!this.state.open) {
      this.setState({open: true});
    }
  }

  handleClose = () => {
    this.setState({open: false});
  }

  render() {
    const { game } = this.props;
    const gameName = `${game.homeName} vs ${game.awayName}`

    const input = {
      gameId: game.id,
      homeScore: game.homeScore || 0,
      awayScore: game.awayScore || 0
    };

    return (
      <TableRow hover onClick={this.handleClick}>
        <TableCell>{gameName}</TableCell>
        <TableCell>{game.division.name}</TableCell>
        <TableCell>{game.pool}</TableCell>
        <TableCell>
          <Badge
            color="primary"
            style={{paddingTop: 0, paddingRight: 15}}
            badgeContent={game.scoreReports!.length}
          >
            {game.homeScore} - {game.awayScore}
          </Badge>
        </TableCell>
        <Modal
          open={this.state.open}
          onClose={this.handleClose}
          title={gameName}
        >
          <ScoreForm input={input} cancel={this.handleClose} />
          <div style={{paddingBottom: 24}}>
            {game.scoreReports!.map((r) => <ScoreReport key={r.id} report={r}/>)}
          </div>
        </Modal>
      </TableRow>
    );
  }
}

export default createFragmentContainer(GameListItem, {
  game: graphql`
    fragment GameListItem_game on Game {
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
      scoreReports {
        id
        ...ScoreReport_report
      }
    }
  `
});
