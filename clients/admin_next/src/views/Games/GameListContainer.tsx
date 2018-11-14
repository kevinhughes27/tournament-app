import * as React from "react";
import { requestSubscription, graphql } from "react-relay";
import { RecordSourceSelectorProxy } from "relay-runtime";
import environment from "../../helpers/relay";
import renderQuery from "../../helpers/renderHelper";
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
    requestSubscription(
      environment,
      {
        subscription,
        variables: {},
        updater,
        onCompleted: () => {/* server closed the subscription */},
        onError: error => console.error(error),
      }
    )
  }

  render() {
    return renderQuery(query, {}, GameList);
  }
}

export default GameListContainer;
