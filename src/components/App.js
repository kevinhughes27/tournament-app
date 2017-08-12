import React, { Component } from 'react';
import Center from 'react-center';
import { connect } from 'react-redux';
import ScheduleList from './ScheduleList';

import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import AppBar from 'material-ui/AppBar';
import IconButton from 'material-ui/IconButton';
import {
  BottomNavigation,
  BottomNavigationItem
} from 'material-ui/BottomNavigation';
import CircularProgress from 'material-ui/CircularProgress';

import LocationOn from 'material-ui-icons/LocationOn';
import Search from 'material-ui-icons/Search';

class App extends Component {
  state = {
    selectedIndex: 0
  };

  select = index => this.setState({ selectedIndex: index });

  render() {
    return (
      <MuiThemeProvider style={{ height: '100%' }}>
        <div>
          {renderTopBar()}
          <div style={{ paddingTop: 64 }}>
            {renderContent(this.props)}
          </div>
          {renderBottomBar(this.state.selectedIndex, this.select)}
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
          <Search />
        </IconButton>
      }
    />
  );
}

function renderContent(props) {
  const { loading, games, search } = props;

  if (loading) {
    return (
      <Center>
        <CircularProgress size={80} thickness={5} />
      </Center>
    );
  } else {
    return <ScheduleList games={games} search={search} />;
  }
}

function renderBottomBar(selectedIndex, select) {
  return (
    <BottomNavigation
      style={{ position: 'fixed', bottom: 0, zIndex: 100 }}
      selectedIndex={selectedIndex}
    >
      <BottomNavigationItem
        label="Recents"
        icon={<LocationOn />}
        onTouchTap={() => select(0)}
      />
      <BottomNavigationItem
        label="Favorites"
        icon={<LocationOn />}
        onTouchTap={() => select(1)}
      />
      <BottomNavigationItem
        label="Nearby"
        icon={<LocationOn />}
        onTouchTap={() => select(2)}
      />
    </BottomNavigation>
  );
}

export default connect(state => ({
  loading: state.app.loading,
  games: state.app.games,
  search: state.app.search
}))(App);
