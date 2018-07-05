import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";

import FieldList from "./FieldList";
import Loader from "../../components/Loader";

const query = graphql`
  query FieldListContainerQuery {
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
    return <FieldList fields={props.fields}/>;
  } else {
    return <Loader />;
  }
};

class FieldListContainer extends React.Component {
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

export default FieldListContainer;
