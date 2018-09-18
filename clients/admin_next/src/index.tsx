import * as React from "react";
import * as ReactDOM from "react-dom";
import withTheme from "./assets/theme";
import App from "./App";

import "react-datepicker/dist/react-datepicker.css";
import "react-leaflet-search/src/react-leaflet-search.css";

import "./assets/css/map.css";
import "./assets/css/schedule.css";
import "./assets/css/bracket.css";
import "./assets/css/userProfile.css";

const ThemedApp = withTheme(App);

ReactDOM.render(
  <ThemedApp />,
  document.getElementById("root")
);
