import React, { Component } from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import { connect } from 'react-redux';
import ScheduleList from './ScheduleList';

class App extends Component {
  render() {
    const { loading, games } = this.props;

    if (loading) {
      return <div>Loading ...</div>;
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
