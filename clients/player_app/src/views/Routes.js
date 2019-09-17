import React, { Component } from 'react';
import { Route } from 'react-router';

import ScheduleView from './ScheduleView';
import MapView from './MapView';
import SubmitView from './SubmitView';

class Routes extends Component {
  render() {
    return (
      <div>
        <Route exact path="/" component={ScheduleView} />
        <Route path="/map" component={MapView} />
        <Route exact path="/submit" component={SubmitView} />
      </div>
    );
  }
}

export default Routes;
