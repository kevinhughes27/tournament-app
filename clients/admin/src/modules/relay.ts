import { Environment, Network, RecordSource, Store, CacheConfig, Variables, RequestNode } from "relay-runtime";
import RelayQueryResponseCache from "relay-runtime/lib/RelayQueryResponseCache";
import auth from "./auth";

export const cache = new RelayQueryResponseCache({ size: 250, ttl: 60 * 5 * 1000 });

const fetchQuery = (
  operation: RequestNode,
  variables: Variables,
  cacheConfig: CacheConfig
) => {
  const queryID = operation.name;
  const forceLoad = cacheConfig && cacheConfig.force;
  const cachedData = cache.get(queryID, variables);

  // serve the cache if possible
  if (!forceLoad && cachedData) {
    return cachedData;
  }

  // clear the (whole) cache. this option is set for all mutations
  if (forceLoad) {
    cache.clear();
  }

  const headers = {
    "content-type": "application/json",
    "Authorization": `Bearer ${auth.getToken()}`
  };

  const body = JSON.stringify({
    query: operation.text,
    variables,
  });

  return fetch("/graphql", {
    method: "POST",
    headers,
    body,
  }).then((response) => {
    return response.json();
  }).then((data) => {
    if (operation.operationKind !== "mutation") {
      cache.set(queryID, variables, data);
    }

    return data;
  });
};

const network = Network.create(fetchQuery);

const store = new Store(new RecordSource())

const modernEnvironment = new Environment({network, store});

export default modernEnvironment;
