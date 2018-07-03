import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";

import List from "./list";
import Loader from "../../components/Loader";

const query = graphql`
  query GamesQuery {
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
    return <List games={props.games}/>;
  } else {
    return <Loader />;
  }
};

class GamesView extends React.Component {
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

export default GamesView;
