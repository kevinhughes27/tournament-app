import * as React from "react";
import { BrowserRouter as Router } from "react-router-dom";

import withTheme from "./withTheme";
import { withStyles, WithStyles } from "@material-ui/core/styles";

import Login from "./Login";
import Admin from "../Admin";

const styles = {};

interface Props extends WithStyles<typeof styles> {}

class App extends React.Component<Props> {
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

export default withTheme(withStyles(styles)(App));
