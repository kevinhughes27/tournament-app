import * as React from "react";
import { BrowserRouter as Router } from "react-router-dom";

import withTheme from "./withTheme";

import Login from "./Login";
import Admin from "../Admin";

class App extends React.Component {
  render() {
    return (
      <Router basename={process.env.PUBLIC_URL}>
        <Login>
          <Admin />
        </Login>
      </Router>
    );
  }
}

export default withTheme(App);
