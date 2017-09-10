import React, { Component } from 'react';
import { Route } from 'react-router';

import Loader from './Loader';
import ScheduleView from './ScheduleView';
import MapView from './MapView';
import SubmitView from './SubmitView';

class App extends Component {
  render() {
    return (
      <Loader>
        <Route exact path="/" component={ScheduleView} />
        <Route path="/map" component={MapView} />
        <Route exact path="/submit" component={SubmitView} />
      </Loader>
    );
  }
}

export default App;
