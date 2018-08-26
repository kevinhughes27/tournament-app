import * as React from "react";
import * as ReactDOM from "react-dom";
import App from "./components/App";

import "react-datepicker/dist/react-datepicker.css";
import "react-leaflet-search/src/react-leaflet-search.css";

import "./assets/css/map.css";
import "./assets/css/schedule.css";
import "./assets/css/bracket.css";

ReactDOM.render(
  <App />,
  document.getElementById("root")
);
