import * as React from "react";
import environment from "../../../relay";
import { graphql, QueryRenderer } from "react-relay";

import List from "./list";
import Loader from "../../Loader";

const query = graphql`
  query FieldsQuery {
    fields {
      id
      name
      lat
      long
    }
  }
`;

const render = ({error, props}: any) => {
  if (error) {
    return <div>{error.message}</div>;
  } else if (props) {
    return <List fields={props.fields}/>;
  } else {
    return <Loader />;
  }
};

class FieldsPage extends React.Component {
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

export default FieldsPage;
