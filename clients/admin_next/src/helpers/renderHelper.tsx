import * as React from "react";
import { QueryRenderer } from "react-relay";
import Loader from "../components/Loader";
import environment from "../relay";

interface Options {
  props?: React.Props<any>;
  loader?: React.ComponentType<any>;
}

const renderQuery = (
  query: any,
  variables: any,
  component: React.ComponentType<any>,
  options: Options = {}
) => {
  return (
    <QueryRenderer
      environment={environment}
      query={query}
      variables={variables}
      render={render(component, options)}
    />
  );
};

const render = (Component: React.ComponentType<any>, options: Options) => {
  const loader = options.loader && <options.loader/> || <Loader />;

  return ({error, props}: any) => {
    if (error) {
      return <div>{error.message}</div>;
    } else if (props) {
      return <Component {...props} {...options.props} />;
    } else {
      return loader;
    }
  };
};

export default renderQuery;
