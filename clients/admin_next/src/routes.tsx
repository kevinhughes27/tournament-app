import * as React from "react";
import { Route } from "react-router-dom";

import Home from "./views/Home";
import {TeamList, TeamShow } from "./views/Teams";
import { DivisionList } from "./views/Divisions";
import { FieldList } from "./views/Fields";
import Schedule from "./views/Schedule";
import { GameList } from "./views/Games";

const Routes = () => (
  <div>
    <Route exact path="/" component={Home} />
    <Route exact path="/teams" component={TeamList} />
    <Route path="/teams/:teamId" component={TeamShow} />
    <Route path="/divisions" component={DivisionList} />
    <Route path="/fields" component={FieldList} />
    <Route path="/schedule" component={Schedule} />
    <Route path="/games" component={GameList} />
  </div>
);

export default Routes;
