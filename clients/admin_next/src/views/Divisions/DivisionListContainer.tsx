import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";

import DivisionList from "./DivisionList";
import Loader from "../../components/Loader";

const query = graphql`
  query DivisionListContainerQuery {
    divisions {
      id
      name
      bracketType
      teamsCount
      numTeams
      isSeeded
    }
  }
`;

const render = ({error, props}: any) => {
  if (error) {
    return <div>{error.message}</div>;
  } else if (props) {
    return <DivisionList divisions={props.divisions}/>;
  } else {
    return <Loader />;
  }
};

class DivisionListContainer extends React.Component {
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

export default DivisionListContainer;
