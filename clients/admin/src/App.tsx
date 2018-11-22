import * as React from "react";
import { BrowserRouter as Router } from "react-router-dom";

import Login from "./views/Login";
import Dashboard from "./views/Dashboard";

class App extends React.Component {
  render() {
    return (
      <Router basename={process.env.PUBLIC_URL}>
        <Login>
          <Dashboard />
        </Login>
      </Router>
    );
  }
}

export default App;
