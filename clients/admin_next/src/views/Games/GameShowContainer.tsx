import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

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

    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{gameId}}
        render={render(GameShow)}
      />
    );
  }
}

export default withRouter(GameShowContainer);
