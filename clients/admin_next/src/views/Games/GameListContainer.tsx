import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";

import GameList from "./GameList";
import Loader from "../../components/Loader";

const query = graphql`
  query GameListContainerQuery {
    games {
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
  }
`;

const render = ({error, props}: any) => {
  if (error) {
    return <div>{error.message}</div>;
  } else if (props) {
    return <GameList games={props.games}/>;
  } else {
    return <Loader />;
  }
};

class GameListContainer extends React.Component {
  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{}}
        render={render}
      />
    );
  }
}

export default GameListContainer;
