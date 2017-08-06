import React, { Component } from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import CircularProgress from 'material-ui/CircularProgress';
import Center from 'react-center';
import { connect } from 'react-redux';
import ScheduleList from './ScheduleList';

class App extends Component {
  render() {
    const { loading, games } = this.props;

    if (loading) {
      return (
        <MuiThemeProvider style={{ height: '100%' }}>
          <Center>
            <CircularProgress size={80} thickness={5} />
          </Center>
        </MuiThemeProvider>
      );
    } else {
      return (
        <MuiThemeProvider>
          <ScheduleList games={games} />
        </MuiThemeProvider>
      );
    }
  }
}

export default connect(state => ({
  loading: state.loading,
  games: state.games
}))(App);
