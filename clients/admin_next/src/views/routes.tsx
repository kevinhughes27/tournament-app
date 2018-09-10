import * as React from "react";
import { Switch, Route } from "react-router-dom";

import Home from "./Home";
import {TeamList, TeamShow, TeamNew } from "./Teams";
import { DivisionList, DivisionShow, DivisionEdit, DivisionNew } from "./Divisions";
import Fields from "./Fields";
import Schedule from "./Schedule";
import { GameList, GameShow } from "./Games";
import { UserEditForm } from "./UserMenu";

const Routes = () => (
  <Switch>
    <Route exact path="/" component={Home}/>

    <Route exact path="/settings" component={UserEditForm}/>

    <Route exact path="/teams" component={TeamList}/>
    <Route path="/teams/new" component={TeamNew}/>
    <Route path="/teams/:teamId" component={TeamShow}/>

    <Route exact path="/divisions" component={DivisionList}/>
    <Route path="/divisions/new" component={DivisionNew}/>
    <Route path="/divisions/:divisionId/edit" component={DivisionEdit}/>
    <Route path="/divisions/:divisionId" component={DivisionShow}/>

    <Route path="/fields" component={Fields}/>
    <Route path="/schedule" component={Schedule}/>

    <Route exact path="/games" component={GameList}/>
    <Route path="/games/:gameId" component={GameShow}/>
  </Switch>
);

export default Routes;
