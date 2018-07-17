import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Breadcrumbs from "../../components/Breadcrumbs";

const styles = {};

interface Props extends WithStyles<typeof styles> {
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
      </div>
    );
  }
}

const StyledGameShow = withStyles(styles)(GameShow);

export default createFragmentContainer(StyledGameShow, {
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
