import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderQuery";
import GameShow from "./GameShow";

interface Props extends RouteComponentProps<any> {}

class GameShowContainer extends React.Component<Props> {
  render() {
    const gameId = this.props.match.params.gameId;

    const query = graphql`
      query GameShowContainerQuery($gameId: ID!) {
        game(id: $gameId) {
          ...GameShow_game
        }
      }
    `;

    return renderQuery(query, {gameId}, GameShow);
  }
}

export default withRouter(GameShowContainer);
