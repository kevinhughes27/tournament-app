import * as React from "react";
import { subscription } from "../../queries/GamesListQuery";

import AppBar from "@material-ui/core/AppBar";
import Badge from "@material-ui/core/Badge";
import Tabs from "@material-ui/core/Tabs";
import Tab from "@material-ui/core/Tab";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import GameListItem from "./GameListItem";
import BlankSlate from "../../components/BlankSlate";

interface Props {
  games: GameListQuery['games'];
  subscribeToMore: any,
}

class GameList extends React.Component<Props> {
  state = {
    tab: 0,
  };

  componentDidMount() {
    this.props.subscribeToMore({
      document: subscription,
      updateQuery: (prev: any, { subscriptionData }: any) => {
        if (!subscriptionData.data) return prev;

        const updatedGame = subscriptionData.data.gameUpdated;
        const gameIdx = prev.games.findIndex((g: GameListQuery_games) => {
          return g.id === updatedGame.id
        });

        Object.assign(prev.games[gameIdx], updatedGame);

        return {
          games: prev.games
        };
      },
    });
  }

  handleTab = (_event: any, tab: number) => {
    this.setState({ tab });
  }

  renderContent = () => {
    const tab = this.state.tab;
    const games = this.props.games;

    const currentGames = games.filter((g) => {
      const started = g.startTime && new Date(g.startTime) < new Date();
      const finished = g.endTime && new Date(g.endTime) < new Date();
      return started && !finished;
    });

    const missingScores = games.filter((g) => {
      const finished = g.endTime && new Date(g.endTime) < new Date();
      return (finished && !g.scoreConfirmed) || g.scoreDisputed;
    });

    const upcomingGames = games.filter((g) => {
      const future = g.startTime && new Date(g.startTime) > new Date();
      return future;
    });

    const finishedGames = games.filter((g) => {
      return g.scoreConfirmed;
    });

    if (games.length > 0) {
      return (
        <div style={{maxWidth: "100%"}}>
          <AppBar position="static" color="default" style={{paddingTop: 5}}>
            <Tabs
              value={tab}
              onChange={this.handleTab}
              scrollable
              scrollButtons="auto"
            >
              {this.renderTab("On Now", currentGames.length, "secondary")}
              {this.renderTab("Need Scores", missingScores.length, "error")}
              {this.renderTab("Upcoming", upcomingGames.length, "secondary")}
              {this.renderTab("Finished", finishedGames.length, "primary")}
            </Tabs>
          </AppBar>
          {tab === 0 && this.renderList(currentGames, "No Games happening now")}
          {tab === 1 && this.renderList(missingScores, "No Games missing scores")}
          {tab === 2 && this.renderList(upcomingGames, "No Games coming up")}
          {tab === 3 && this.renderList(finishedGames, "No Games finished")}
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

  renderTab = (name: string, count: number, color: "primary" | "secondary" | "error" | "default") => (
    <Tab
      label={
        <Badge badgeContent={count} color={color} style={{paddingTop: 0, paddingRight: 15}}>
          {name}
        </Badge>
      }
    />
  )

  renderList = (games: GameListQuery['games'], blankCopy: string) => {
    if (games.length > 0) {
      return (
        <div style={{maxWidth: "100%", overflowX: "scroll"}}>
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
      )
    } else {
      return (
        <BlankSlate>
          <p>{blankCopy}</p>
        </BlankSlate>
      );
    }
  }

  render() {
    return this.renderContent();
  }
}

export default GameList;
