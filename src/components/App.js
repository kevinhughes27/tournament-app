import React, { Component } from 'react';
import { Route } from 'react-router';
import { connect } from 'react-redux';
import queryString from 'query-string';

import Loader from './Loader';
import ScheduleView from './ScheduleView';
import MapView from './MapView';
import SubmitView from './SubmitView';

class App extends Component {
  componentWillMount() {
    teamDeepLink(this.props.params, this.props.dispatch);
  }

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

function teamDeepLink(params, dispatch) {
  const teamName = params['teamName'];

  if (teamName) {
    dispatch({ type: 'SET_SEARCH', value: teamName });
  }
}

export default connect(state => ({
  params: queryString.parse(state.router.location.search)
}))(App);
