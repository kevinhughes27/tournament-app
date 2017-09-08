import React, { Component } from 'react';
import { MuiThemeProvider, createMuiTheme } from 'material-ui/styles';
import TopBar from './TopBar';
import BottomNav from './BottomNav';

const theme = createMuiTheme();

class Layout extends Component {
  render() {
    return (
      <MuiThemeProvider theme={theme}>
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
