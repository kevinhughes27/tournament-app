import React, { Component } from 'react';
import { connect } from 'react-redux';
import { push } from 'react-router-redux';
import {
  BottomNavigation,
  BottomNavigationItem
} from 'material-ui/BottomNavigation';
import EventIcon from 'material-ui-icons/Event';
import LocationIcon from 'material-ui-icons/LocationOn';
import SendIcon from 'material-ui-icons/Send';

class BottomNav extends Component {
  render() {
    const { location, dispatch } = this.props;

    const pathToIndex = {
      null: 0,
      '/': 0,
      '/map': 1,
      '/submit': 2
    };
    const selectedIndex = pathToIndex[location];

    return (
      <BottomNavigation
        style={{ position: 'fixed', bottom: 0, zIndex: 100 }}
        selectedIndex={selectedIndex}
      >
        <BottomNavigationItem
          label="Schedule"
          icon={<EventIcon />}
          onTouchTap={() => dispatch(push('/'))}
        />
        <BottomNavigationItem
          label="Map"
          icon={<LocationIcon />}
          onTouchTap={() => dispatch(push('/map'))}
        />
        <BottomNavigationItem
          label="Submit Scores"
          icon={<SendIcon />}
          onTouchTap={() => dispatch(push('/submit'))}
        />
      </BottomNavigation>
    );
  }
}

export default connect(state => ({
  location: state.router.location
}))(BottomNav);
