import * as React from "react";
import { ApolloProvider } from "react-apollo";
import { BrowserRouter as Router } from "react-router-dom";

import Login from "./views/Login";
import Dashboard from "./views/Dashboard";

import client from "./modules/apollo";

const App = () => (
  <ApolloProvider client={client}>
    <Router basename={process.env.PUBLIC_URL}>
      <Login>
        <Dashboard />
      </Login>
    </Router>
  </ApolloProvider>
);

export default App;
