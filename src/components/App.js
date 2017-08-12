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
          <AppBar
            title="Ultimate Tournament"
            style={{ position: 'fixed' }}
            iconElementLeft={
              <IconButton>
                <Search />
              </IconButton>
            }
          />
          <div style={{ paddingTop: 64 }}>{renderContent(this.props)}</div>}
          <BottomNavigation
            style={{ position: 'fixed', bottom: 0, zIndex: 100 }}
            selectedIndex={this.state.selectedIndex}
          >
            <BottomNavigationItem
              label="Recents"
              icon={<LocationOn />}
              onTouchTap={() => this.select(0)}
            />
            <BottomNavigationItem
              label="Favorites"
              icon={<LocationOn />}
              onTouchTap={() => this.select(1)}
            />
            <BottomNavigationItem
              label="Nearby"
              icon={<LocationOn />}
              onTouchTap={() => this.select(2)}
            />
          </BottomNavigation>
        </div>
      </MuiThemeProvider>
    );
  }
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

export default connect(state => ({
  loading: state.loading,
  games: state.games,
  search: state.search
}))(App);
