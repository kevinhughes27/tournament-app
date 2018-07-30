import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import ScoreForm from "./ScoreForm";

interface Props {
  game: GameShow_game;
}

class GameShow extends React.Component<Props> {
  render() {
    const { game } = this.props;

    const input = {
      gameId: game.id,
      homeScore: game.homeScore || 0,
      awayScore: game.awayScore || 0
    };

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/games", text: "Games"},
            {text: `${game.homeName} vs ${game.awayName}` }
          ]}
        />
        <ScoreForm input={input} />
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
