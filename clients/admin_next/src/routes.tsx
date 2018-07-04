import * as React from "react";
import { Route } from "react-router-dom";

import Home from "./views/Home";
import Teams from "./views/Teams";
import Team from "./views/Teams/show";
import Divisions from "./views/Divisions";
import Fields from "./views/Fields";
import Schedule from "./views/Schedule";
import Games from "./views/Games";

const Routes = () => (
  <div>
    <Route exact path="/" component={Home} />
    <Route exact path="/teams" component={Teams} />
    <Route path="/teams/:teamId" component={Team} />
    <Route path="/divisions" component={Divisions} />
    <Route path="/fields" component={Fields} />
    <Route path="/schedule" component={Schedule} />
    <Route path="/games" component={Games} />
  </div>
);

export default Routes;
