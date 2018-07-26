import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
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
    return renderQuery(query, {}, GameList);
  }
}

export default GameListContainer;
