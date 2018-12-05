import * as React from "react";
import { Query } from "react-apollo";
import { QueryRenderer } from "react-relay";
import Loader from "../components/Loader";
import environment from "../modules/relay";

interface Options {
  props?: React.Props<any>;
  loader?: React.ComponentType<any>;
}

const renderQuery = (
  query: any,
  variables: any,
  Component: React.ComponentType<any>,
  options: Options = {}
) => {
  const loader = options.loader && <options.loader/> || <Loader />;
  const isApollo = typeof(query) === 'object';

  if (isApollo) {
    return (
      <Query query={query} variables={variables}>
        {({ loading, error, data }) => {
          if (loading) return loader;

          if (error) return <div>{error.message}</div>;

          return <Component {...data} {...options.props} />;
        }}
      </Query>
    )
  } else {
    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={variables}
        render={render(Component, loader, options)}
      />
    );
  }
};

const render = (
  Component: React.ComponentType<any>,
  Loader: React.ReactElement<any>,
  options: Options
) => {
  return ({error, props}: any) => {
    if (error) {
      return <div>{error.message}</div>;
    } else if (props) {
      return <Component {...props} {...options.props} />;
    } else {
      return Loader;
    }
  };
};

export default renderQuery;
