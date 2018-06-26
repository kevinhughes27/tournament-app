import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";

import List from "./list";

const query = graphql`
	query TeamsQuery {
		teams {
      id
      name
      seed
		}
	}
`;

class Teams extends React.Component {
  public render() {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        render={({error, props}) => {
          if (error) {
            return <div>{error.message}</div>;
          } else if (props) {
            const teams = props.teams;
            return <List teams={teams}/>;
          } else {
            return <div>Loading</div>;
          }
        }}
      />
    );
  }
}

export default Teams;
