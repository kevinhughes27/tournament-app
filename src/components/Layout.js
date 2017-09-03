import React, { Component } from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import TopBar from './TopBar';
import BottomNav from './BottomNav';

class Layout extends Component {
  render() {
    return (
      <MuiThemeProvider>
        <div>
          <div className="topbar">
            <TopBar />
          </div>

          <div className="content">
            {this.props.children}
          </div>

          <div className="bottombar">
            <BottomNav />
          </div>
        </div>
      </MuiThemeProvider>
    );
  }
}

export default Layout;
