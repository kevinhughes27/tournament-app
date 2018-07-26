import * as React from "react";
import { QueryRenderer } from "react-relay";
import Loader from "../components/Loader";
import environment from "../relay";

const renderQuery = (
  query: any,
  variables: any,
  component: React.ComponentType<any>
) => {
  return (
    <QueryRenderer
      environment={environment}
      query={query}
      variables={variables}
      render={render(component)}
    />
  );
};

const render = (Component: React.ComponentType<any>) =>
  ({error, props}: any) => {
    if (error) {
      return <div>{error.message}</div>;
    } else if (props) {
      return <Component {...props}/>;
    } else {
      return <Loader />;
    }
  };

export default renderQuery;
