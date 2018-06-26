import * as React from "react";
import { Route } from "react-router-dom";

import Home from "./pages/Home";
import Teams from "./pages/Teams";
import Divisions from "./pages/Divisions";
import Fields from "./pages/Fields";
import Schedule from "./pages/Schedule";
import Games from "./pages/Games";

const Routes = () => (
  <div>
    <Route exact path="/" component={Home} />
    <Route path="/teams" component={Teams} />
    <Route path="/divisions" component={Divisions} />
    <Route path="/fields" component={Fields} />
    <Route path="/schedule" component={Schedule} />
    <Route path="/games" component={Games} />
  </div>
);

export default Routes;
