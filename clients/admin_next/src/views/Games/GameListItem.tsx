import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import TableCell from "@material-ui/core/TableCell";
import TableRow from "@material-ui/core/TableRow";
import Modal from "../../components/Modal";
import ScoreForm from "./ScoreForm";
import ScoreReport from "./ScoreReport";
import ReportsBadge from "./ReportsBadge";

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

    return (
      <TableRow hover onClick={this.handleClick}>
        <TableCell>{gameName}</TableCell>
        <TableCell>{game.division.name}</TableCell>
        <TableCell>{game.pool}</TableCell>
        {this.renderScoreCell()}
        {this.renderModal()}
      </TableRow>
    );
  }

  renderScoreCell = () => {
    const { game } = this.props;
    const reportCount = (game.scoreReports || []).length;

    if (game.homeScore && game.awayScore) {
      return(
        <TableCell>
          <ReportsBadge count={reportCount} disputed={game.scoreDisputed}>
            {game.homeScore} - {game.awayScore}
          </ReportsBadge>
        </TableCell>
      );
    } else {
      return <TableCell></TableCell>
    }
  }

  renderModal = () => {
    const { game } = this.props;
    const gameName = `${game.homeName} vs ${game.awayName}`

    const input = {
      gameId: game.id,
      homeScore: game.homeScore || 0,
      awayScore: game.awayScore || 0
    };

    if (game.hasTeams) {
      return(
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
      );
    } else {
      return null;
    }
  }
}

export default createFragmentContainer(GameListItem, {
  game: graphql`
    fragment GameListItem_game on Game {
      id
      pool
      homeName
      awayName
      hasTeams
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
      scoreDisputed
    }
  `
});
