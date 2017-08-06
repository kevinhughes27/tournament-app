import React, { Component } from 'react';
import Center from 'react-center';
import { connect } from 'react-redux';
import ScheduleList from './ScheduleList';

import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import AppBar from 'material-ui/AppBar';
import {
  BottomNavigation,
  BottomNavigationItem
} from 'material-ui/BottomNavigation';
import CircularProgress from 'material-ui/CircularProgress';
import FontIcon from 'material-ui/FontIcon';
import IconLocationOn from 'material-ui/svg-icons/communication/location-on';

const recentsIcon = <FontIcon className="material-icons">restore</FontIcon>;
const favoritesIcon = <FontIcon className="material-icons">favorite</FontIcon>;
const nearbyIcon = <IconLocationOn />;

class App extends Component {
  state = {
    selectedIndex: 0
  };

  select = index => this.setState({ selectedIndex: index });

  render() {
    return (
      <MuiThemeProvider style={{ height: '100%' }}>
        <div>
          <AppBar title="Ultimate Tournament" />
          {renderContent(this.props)}
          <BottomNavigation selectedIndex={this.state.selectedIndex}>
            <BottomNavigationItem
              label="Recents"
              icon={recentsIcon}
              onTouchTap={() => this.select(0)}
            />
            <BottomNavigationItem
              label="Favorites"
              icon={favoritesIcon}
              onTouchTap={() => this.select(1)}
            />
            <BottomNavigationItem
              label="Nearby"
              icon={nearbyIcon}
              onTouchTap={() => this.select(2)}
            />
          </BottomNavigation>
        </div>
      </MuiThemeProvider>
    );
  }
}

function renderContent(props) {
  const { loading, games } = props;

  if (loading) {
    return (
      <Center>
        <CircularProgress size={80} thickness={5} />
      </Center>
    );
  } else {
    return <ScheduleList games={games} />;
  }
}

export default connect(state => ({
  loading: state.loading,
  games: state.games
}))(App);
