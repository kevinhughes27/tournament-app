import * as React from 'react';
import { Query } from 'react-apollo';
import Loader from '../components/Loader';
import NotFound from '../views/NotFound';
import BlankSlate from '../components/BlankSlate';
import { isEmpty } from 'lodash';

interface Options {
  props?: React.Props<any>;
  loader?: React.ComponentType<any>;
  fetchPolicy?: 'cache-first' | 'cache-and-network' | 'network-only';
}

const renderQuery = (
  query: any,
  variables: any,
  Component: React.ComponentType<any>,
  options: Options = {}
) => {
  const loader = (options.loader && <options.loader />) || <Loader />;
  const fetchPolicy = options.fetchPolicy || 'cache-first';

  return (
    <Query query={query} variables={variables} fetchPolicy={fetchPolicy}>
      {({ loading, error, data, subscribeToMore }: any) => {
        if (error) {
          if (
            error.networkError &&
            (error.networkError as any).response.status === 404
          ) {
            return <NotFound />;
          } else {
            return <BlankSlate>{error.message}</BlankSlate>;
          }
        }

        // prefer showing stale data for a split second opposed to the loader
        if (loading && isEmpty(data)) return loader;

        return (
          <Component
            {...data}
            {...options.props}
            subscribeToMore={subscribeToMore}
          />
        );
      }}
    </Query>
  );
};

export default renderQuery;
