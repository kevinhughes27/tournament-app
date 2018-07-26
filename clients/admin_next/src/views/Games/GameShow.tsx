import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import Breadcrumbs from "../../components/Breadcrumbs";
import ScoreForm from "./ScoreForm";

interface Props {
  game: Game;
}

class GameShow extends React.Component<Props> {
  render() {
    const { game } = this.props;

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/games", text: "Games"},
            {text: `${game.homeName} vs ${game.awayName}` }
          ]}
        />
        <ScoreForm game={game} />
      </div>
    );
  }
}

export default createFragmentContainer(GameShow, {
  game: graphql`
    fragment GameShow_game on Game {
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
