import React, { Component } from 'react';
import { connect } from 'react-redux';
import queryString from 'query-string';

import Loader from './Loader';
import Routes from './Routes';

class App extends Component {
  componentWillMount() {
    teamDeepLink(this.props.params, this.props.dispatch);
  }

  render() {
    return (
      <Loader>
        <Routes />
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
