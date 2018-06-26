import * as React from "react";
import environment from "../../../relay";
import { graphql, QueryRenderer } from "react-relay";

import List from "./list";
import Loader from "../../Loader";

const query = graphql`
  query GamesQuery {
    games {
      id
      homeName
      awayName
      homeScore
      awayScore
    }
  }
`;

const render = ({error, props}: any) => {
  if (error) {
    return <div>{error.message}</div>;
  } else if (props) {
    return <List games={props.games}/>;
  } else {
    return <Loader />;
  }
};

class GamesPage extends React.Component {
  render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        render={render}
      />
    );
  }
}

export default GamesPage;
