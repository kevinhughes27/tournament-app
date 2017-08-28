import React, { Component } from 'react';
import { connect } from 'react-redux';
import Center from 'react-center';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import CircularProgress from 'material-ui/CircularProgress';
import TopBar from './TopBar';
import BottomNav from './BottomNav';

// main responsibilty is loading.
// I need to make a new component for the main page layout
// and move that logic there.
//    * Should I rename this to Loader?
// needs to support optional bottom nav.
// should do top and bottom with proper flex container.

class App extends Component {
  render() {
    return (
      <MuiThemeProvider style={{ height: '100%' }}>
        <div>
          <TopBar />
          <div style={{ paddingTop: 64, paddingBottom: 64 }}>
            {renderContent(this.props)}
          </div>
          <BottomNav />
        </div>
      </MuiThemeProvider>
    );
  }
}

function renderContent(props) {
  const { loading } = props;

  if (loading) {
    return (
      <Center>
        <CircularProgress size={80} thickness={5} />
      </Center>
    );
  } else {
    return props.children;
  }
}

export default connect(state => ({
  loading: state.app.loading,
  location: state.router.location
}))(App);
