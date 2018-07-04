import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";

import View from "./list";
import Loader from "../../components/Loader";

const query = graphql`
  query listContainerQuery {
    teams {
      id
      name
      division {
        id
        name
      }
      seed
    }
  }
`;

const render = ({error, props}: any) => {
  if (error) {
    return <div>{error.message}</div>;
  } else if (props) {
    return <View teams={props.teams}/>;
  } else {
    return <Loader />;
  }
};

class Container extends React.Component {
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

export default Container;
