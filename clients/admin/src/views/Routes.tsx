import * as React from 'react';
import { Switch, Route } from 'react-router-dom';

import Home from './Home';
import User from './User';
import Settings from './Settings';
import { TeamList, TeamShow, TeamNew } from './Teams';
import {
  DivisionList,
  DivisionShow,
  DivisionSeed,
  DivisionEdit,
  DivisionNew
} from './Divisions';
import Fields from './Fields';
import Schedule from './Schedule';
import Games from './Games';
import App from './App';

import NotFound from './NotFound';
import ErrorBoundary from './ErrorBoundary';

const Routes = () => (
  <ErrorBoundary>
    <Switch>
      <Route exact path="/" component={Home} />

      <Route path="/user" component={User} />
      <Route path="/settings" component={Settings} />

      <Route exact path="/teams" component={TeamList} />
      <Route path="/teams/new" component={TeamNew} />
      <Route path="/teams/:teamId" component={TeamShow} />

      <Route exact path="/divisions" component={DivisionList} />
      <Route path="/divisions/new" component={DivisionNew} />
      <Route path="/divisions/:divisionId/seed" component={DivisionSeed} />
      <Route path="/divisions/:divisionId/edit" component={DivisionEdit} />
      <Route path="/divisions/:divisionId" component={DivisionShow} />

      <Route path="/fields" component={Fields} />
      <Route path="/schedule" component={Schedule} />

      <Route exact path="/games" component={Games} />
      <Route path="/app" component={App} />

      <Route component={NotFound} />
    </Switch>
  </ErrorBoundary>
);

export default Routes;
