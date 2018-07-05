import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";

import TeamList from "./TeamList";
import Loader from "../../components/Loader";

const query = graphql`
  query TeamListContainerQuery {
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
    return <TeamList teams={props.teams}/>;
  } else {
    return <Loader />;
  }
};

class TeamListContainer extends React.Component {
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

export default TeamListContainer;
