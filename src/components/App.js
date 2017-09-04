import React, { Component } from 'react';
import { Route } from 'react-router';

import Loader from './Loader';
import ScheduleList from './ScheduleList';
import MapView from './MapView';
import Submit from './Submit';

class App extends Component {
  render() {
    return (
      <Loader>
        <Route exact path="/" component={ScheduleList} />
        <Route path="/map" component={MapView} />
        <Route exact path="/submit" component={Submit} />
      </Loader>
    );
  }
}

export default App;
