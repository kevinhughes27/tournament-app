import {
  Environment,
  Network,
  RecordSource,
  Store
} from "relay-runtime";

const fetchQuery = (
  operation: any,
  variables: any
) => {
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
    return response.json()
  });
};

const modernEnvironment = new Environment({
  network: Network.create(fetchQuery),
  store: new Store(new RecordSource()),
});

export default modernEnvironment;
