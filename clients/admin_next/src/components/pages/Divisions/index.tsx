import * as React from "react";
import environment from "../../../relay";
import { graphql, QueryRenderer } from "react-relay";

import List from "./list";
import Loader from "../../Loader";

const query = graphql`
  query DivisionsQuery {
    divisions {
      id
      name
      bracketType
    }
  }
`;

const render = ({error, props}: any) => {
  if (error) {
    return <div>{error.message}</div>;
  } else if (props) {
    return <List divisions={props.divisions}/>;
  } else {
    return <Loader />;
  }
};

class DivisionsPage extends React.Component {
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

export default DivisionsPage;