import * as React from 'react';
import { ApolloProvider } from 'react-apollo';
import { BrowserRouter as Router } from 'react-router-dom';

import Login from './views/Login';
import Dashboard from './views/Dashboard';
import Analytics from './components/Analytics';

import client from './modules/apollo';

const App = () => (
  <ApolloProvider client={client}>
    <Router basename={process.env.PUBLIC_URL}>
      <Analytics>
        <Login>
          <Dashboard />
        </Login>
      </Analytics>
    </Router>
  </ApolloProvider>
);

export default App;
