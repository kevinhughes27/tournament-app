import React, { Component } from 'react';
import { connect } from 'react-redux';
import Center from 'react-center';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import CircularProgress from 'material-ui/CircularProgress';
import TopBar from './TopBar';
import BottomNav from './BottomNav';

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
