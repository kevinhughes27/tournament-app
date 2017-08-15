import React, { Component } from 'react';
import Center from 'react-center';
import { connect } from 'react-redux';
import { push } from 'react-router-redux';

import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import AppBar from 'material-ui/AppBar';
import IconButton from 'material-ui/IconButton';
import {
  BottomNavigation,
  BottomNavigationItem
} from 'material-ui/BottomNavigation';
import CircularProgress from 'material-ui/CircularProgress';

import SearchIcon from 'material-ui-icons/Search';
import EventIcon from 'material-ui-icons/Event';
import LocationIcon from 'material-ui-icons/LocationOn';
import SendIcon from 'material-ui-icons/Send';

class App extends Component {
  render() {
    return (
      <MuiThemeProvider style={{ height: '100%' }}>
        <div>
          {renderTopBar()}
          <div style={{ paddingTop: 64 }}>
            {renderContent(this.props)}
          </div>
          {renderBottomBar(this.props, this.props.dispatch)}
        </div>
      </MuiThemeProvider>
    );
  }
}

function renderTopBar() {
  return (
    <AppBar
      title="Ultimate Tournament"
      style={{ position: 'fixed' }}
      iconElementLeft={
        <IconButton>
          <SearchIcon />
        </IconButton>
      }
    />
  );
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

function renderBottomBar(props, dispatch) {
  const { location } = props;

  const pathToIndex = {
    null: 0,
    '/': 0,
    '/map': 1,
    '/submit': 2
  };
  const selectedIndex = pathToIndex[location];

  return (
    <BottomNavigation
      style={{ position: 'fixed', bottom: 0, zIndex: 100 }}
      selectedIndex={selectedIndex}
    >
      <BottomNavigationItem
        label="Schedule"
        icon={<EventIcon />}
        onTouchTap={() => dispatch(push('/'))}
      />
      <BottomNavigationItem
        label="Map"
        icon={<LocationIcon />}
        onTouchTap={() => dispatch(push('/map'))}
      />
      <BottomNavigationItem
        label="Submit Scores"
        icon={<SendIcon />}
        onTouchTap={() => dispatch(push('/submit'))}
      />
    </BottomNavigation>
  );
}

export default connect(state => ({
  loading: state.app.loading,
  location: state.router.location
}))(App);
