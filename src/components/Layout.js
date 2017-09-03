import React, { Component } from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import TopBar from './TopBar';
import BottomNav from './BottomNav';

class Layout extends Component {
  render() {
    return (
      <MuiThemeProvider>
        <div>
          <TopBar />
          <div style={{ paddingTop: 64, paddingBottom: 64 }}>
            {this.props.children}
          </div>
          <BottomNav />
        </div>
      </MuiThemeProvider>
    );
  }
}

export default Layout;
