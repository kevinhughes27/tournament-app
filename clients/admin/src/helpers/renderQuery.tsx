import * as React from "react";
import { Query } from "react-apollo";
import Loader from "../components/Loader";

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

  return (
    <Query query={query} variables={variables}>
      {({ loading, error, data, subscribeToMore }) => {

        if (loading) return loader;

        if (error) return <div>{error.message}</div>;

        return <Component {...data} {...options.props} subscribeToMore={subscribeToMore} />;
      }}
    </Query>
  )
};

export default renderQuery;
