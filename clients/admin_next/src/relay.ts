import { Environment, Network, RecordSource, Store } from "relay-runtime";
import RelayQueryResponseCache from "relay-runtime/lib/RelayQueryResponseCache";

const cache = new RelayQueryResponseCache({ size: 250, ttl: 60 * 5 * 1000 });

const fetchQuery = (
  operation: any,
  variables: any,
  cacheConfig: any
) => {

  const queryID = operation.name;

  const cachedData = cache.get(queryID, variables);

  // Handle force option in RefetchOptions
  // See: https://facebook.github.io/relay/docs/pagination-container.html
  // https://facebook.github.io/relay/docs/refetch-container.html
  const forceLoad = cacheConfig && cacheConfig.force;

  if (!forceLoad && cachedData) {
    return cachedData;
  }

  if (forceLoad) {
    // clear() means to reset all the cache, not only the entry addressed by specific queryId.
    cache.clear();
  }

  return fetch("/graphql", {
    method: "POST",
    headers: {
      "content-type": "application/json",
    },
    credentials: "include",
    body: JSON.stringify({
      query: operation.text,
      variables,
    }),
  }).then((response) => {
    return response.json();
  }).then((data) => {
    if (operation.operationKind !== "mutation") {
      cache.set(queryID, variables, data);
    }

    return data;
  });
};

const modernEnvironment = new Environment({
  network: Network.create(fetchQuery),
  store: new Store(new RecordSource()),
});

export default modernEnvironment;
