import * as React from "react";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

import GameList from "./GameList";

const query = graphql`
  query GameListContainerQuery {
    games {
      ...GameList_games
    }
  }
`;

class GameListContainer extends React.Component {
  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{}}
        render={render(GameList)}
      />
    );
  }
}

export default GameListContainer;
