import React, { Component } from 'react';
import Loader from './Loader';
import Routes from './Routes';

class App extends Component {
  render() {
    return (
      <Loader>
        <Routes />
      </Loader>
    );
  }
}

export default App;
