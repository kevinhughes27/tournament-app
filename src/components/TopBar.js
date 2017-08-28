import React, { Component } from 'react';
import AppBar from 'material-ui/AppBar';
import IconButton from 'material-ui/IconButton';
import SearchIcon from 'material-ui-icons/Search';

class TopBar extends Component {
  render() {
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
}

export default TopBar;
