import * as React from "react";
import { query } from "../../queries/GamesListQuery";
import renderQuery from "../../helpers/renderQuery";
import GameList from "./GameList";

class GameListContainer extends React.Component {
  render() {
    return renderQuery(query, {}, GameList);
  }
}

export default GameListContainer;
