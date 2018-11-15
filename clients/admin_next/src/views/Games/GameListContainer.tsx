import * as React from "react";
import { graphql } from "react-relay";
import { RecordSourceSelectorProxy } from "relay-runtime";
import renderQuery from "../../helpers/renderHelper";
import requestSubscription from "../../helpers/subscription";
import GameList from "./GameList";

const query = graphql`
  query GameListContainerQuery {
    games {
      ...GameList_games
    }
  }
`;

const subscription = graphql`
  subscription GameListContainerSubscription {
    gameUpdated {
      ...GameListItem_game
    }
  }
`;

function updater(store: RecordSourceSelectorProxy) {
  const root = store.getRoot();
  const games = root.getLinkedRecords("games") || [];
  const updatedGame = store.getRootField("gameUpdated");

  const newGames = games.map((game) => {
    if (game && game.getDataID() === updatedGame!.getValue("id")) {
      return updatedGame
    } else {
      return game;
    }
  });

  root.setLinkedRecords(newGames, "games");
}

class GameListContainer extends React.Component {
  componentDidMount() {
    requestSubscription(subscription, updater);
  }

  render() {
    return renderQuery(query, {}, GameList);
  }
}

export default GameListContainer;
