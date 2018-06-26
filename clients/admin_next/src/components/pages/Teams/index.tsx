import * as React from "react";
import environment from "../../../relay";
import { graphql, QueryRenderer } from "react-relay";

import List from "./list";
import Loader from "../../Loader";

const query = graphql`
  query TeamsQuery {
    teams {
      id
      name
      divisionId
      seed
    }
  }
`;

const render = ({error, props}: any) => {
  if (error) {
    return <div>{error.message}</div>;
  } else if (props) {
    return <List teams={props.teams}/>;
  } else {
    return <Loader />;
  }
};

class TeamsPage extends React.Component {
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

export default TeamsPage;