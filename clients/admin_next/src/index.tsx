import * as React from "react";
import * as ReactDOM from "react-dom";
import App from "./App";

import { graphql, QueryRenderer } from "react-relay";
import { Environment, Network, RecordSource, Store } from "relay-runtime";

const fetchQuery = (operation: any, variables: any) => {
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
  }).then((response) => response.json());
};

const modernEnvironment = new Environment({
  network: Network.create(fetchQuery),
  store: new Store(new RecordSource()),
});

const query = graphql`
	query srcQuery {
		teams {
      id
      name
		}
	}
`;

const renderComponent: (readyState: ReadyState) => React.ReactElement<any> | null = ({error, props}) => {
  if (props) {
    return <App />;
  } else {
    return <div>Loading</div >;
  }
};

ReactDOM.render(
  <QueryRenderer
    environment={modernEnvironment}
    query={query}
    variables={{}}
    render={renderComponent}
  />,
  document.getElementById("root")
);
