import * as React from "react";
import Tabs from "@material-ui/core/Tabs";
import Tab from "@material-ui/core/Tab";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faStop } from "@fortawesome/free-solid-svg-icons";
import { keys, groupBy, sortBy, map, Dictionary } from "lodash";

import UnscheduledGame from "./UnscheduledGame";
import GameColor from "./GameColor";

interface Props {
  games: Game[];
}

interface State {
  tab: number;
}

class UnscheduledGames extends React.Component<Props, State> {
  state = {
    tab: 0
  };

  handleChange = ({}, value: number) => {
    this.setState({ tab: value });
  }

  render() {
    const games = this.props.games;
    const gamesByDivision = groupBy(games, (g) => g.division.name);
    const divisions = keys(gamesByDivision);
    const division = divisions[this.state.tab];

    return (
      <div>
        <Tabs value={this.state.tab} onChange={this.handleChange}>
          {map(gamesByDivision, this.renderTab)}
        </Tabs>
        {this.renderTabContent(gamesByDivision[division])}
      </div>
    );
  }

  renderTab = (games: Game[], divisionName: string) => {
    const color = GameColor(games[0]);

    return (
      <Tab
        key={divisionName}
        label={
          <span>
            <FontAwesomeIcon icon={faStop} style={{color}}/> {divisionName}
          </span>
        }
      />
    );
  }

  renderTabContent = (games: Game[]) => {
    const poolGames = games.filter((g) => !!g.pool);
    const bracketGames = games.filter((g) => !g.pool);

    const poolGamesByRound = groupBy(poolGames, "round");
    const poolRounds = sortBy(keys(poolGamesByRound), (r) => parseInt(r, 10));

    const bracketGamesByRound = groupBy(bracketGames, "round");
    const bracketRounds = sortBy(keys(bracketGamesByRound), (r) => parseInt(r, 10));

    return (
      <div className="unscheduled">
        {this.renderStage("pool", poolRounds, poolGamesByRound)}
        {this.renderStage("bracket", bracketRounds, bracketGamesByRound)}
      </div>
    );
  }

  renderStage = (stage: string, rounds: string[], games: Dictionary<Game[]>) => {
    return map(rounds, (round) => {
      return this.renderGamesRow(stage, round, games[round]);
    });
  }

  renderGamesRow = (stage: string, round: string, games: Game[]) => {
    return (
      <div key={stage + round} style={{display: "flex"}}>
        {map(games, (g) => {
          return <UnscheduledGame key={g.id} game={g}/>;
        })}
      </div>
    );
  }
}

export default UnscheduledGames;
