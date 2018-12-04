import * as React from "react";
import * as ReactDOM from "react-dom";
import { BrowserRouter as Router } from "react-router-dom";
import withTheme from "./assets/theme";
import Login from "./views/Login";
import Dashboard from "./views/Dashboard";

import "react-datepicker/dist/react-datepicker.css";
import "react-leaflet-search/src/react-leaflet-search.css";

import "./assets/css/map.css";
import "./assets/css/home.css";
import "./assets/css/user.css";
import "./assets/css/games.css";
import "./assets/css/device.css";
import "./assets/css/bracket.css";
import "./assets/css/schedule.css";

const App = () => (
  <Router basename={process.env.PUBLIC_URL}>
    <Login>
      <Dashboard />
    </Login>
  </Router>
)

const ThemedApp = withTheme(App);

ReactDOM.render(
  <ThemedApp />,
  document.getElementById("root")
);
