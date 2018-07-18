import * as React from "react";
import { Route } from "react-router-dom";

import Home from "./Home";
import {TeamList, TeamShow } from "./Teams";
import { DivisionList } from "./Divisions";
import { FieldMap } from "./Fields";
import Schedule from "./Schedule";
import { GameList, GameShow } from "./Games";

const Routes = () => (
  <div>
    <Route exact path="/" component={Home} />
    <Route exact path="/teams" component={TeamList} />
    <Route path="/teams/:teamId" component={TeamShow} />
    <Route path="/divisions" component={DivisionList} />
    <Route path="/fields" component={FieldMap} />
    <Route path="/schedule" component={Schedule} />
    <Route exact path="/games" component={GameList} />
    <Route path="/games/:gameId" component={GameShow} />
  </div>
);

export default Routes;
