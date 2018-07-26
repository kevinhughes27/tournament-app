import * as React from "react";
import { keys, map, each, filter, groupBy, sortBy, unionWith, isEqual } from "lodash";
import Pool from "./Pool";

interface Props {
  games: Game[];
}

class Pools extends React.Component<Props> {
  render() {
    const games = this.props.games;
    const teams = teamsByPool(games);
    const pools = keys(teams);

    return (
      <div style={{display: "flex", flexWrap: "wrap", justifyContent: "flex-start"}}>
        { pools.map((pool) =>
          <Pool
            key={pool}
            pool={pool}
            teams={teams[pool]}
          />
        )}
      </div>
    );
  }
}

const teamsByPool = (games: Game[]) => {
  const byPool: any = {};

  const allPoolGames = filter(games, "pool");
  const gamesByPool = groupBy(allPoolGames, "pool");

  each(gamesByPool, (poolGames, pool) => {
    const homeTeams = map(poolGames, (g) => {
      return { seed: g.homePrereq, name: g.homeName };
    });

    const awayTeams = map(poolGames, (g) => {
      return { seed: g.awayPrereq, name: g.awayName };
    });

    const teams = unionWith(homeTeams, awayTeams, isEqual);
    byPool[pool] = sortBy(teams, (t) => t.seed );
  });

  return byPool;
};

export default Pools;
