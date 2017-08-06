import React, { Component } from 'react';
import AppBar from 'material-ui/AppBar';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import CircularProgress from 'material-ui/CircularProgress';
import Center from 'react-center';
import { connect } from 'react-redux';
import ScheduleList from './ScheduleList';

class App extends Component {
  render() {
    return (
      <MuiThemeProvider style={{ height: '100%' }}>
        <div>
          <AppBar title="Ultimate Tournament" />
          {renderContent(this.props)}
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
