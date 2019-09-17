import React, { Component } from 'react';
import Loader from './components/Loader';
import Routes from './views/Routes';

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
