import React, { Component } from 'react';
import { connect } from 'react-redux';
import { push } from 'react-router-redux';
import {
  BottomNavigation,
  BottomNavigationItem
} from 'material-ui/BottomNavigation';
import EventIcon from 'material-ui-icons/Event';
import LocationIcon from 'material-ui-icons/LocationOn';
import InputIcon from 'material-ui-icons/Input';

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
      <BottomNavigation selectedIndex={selectedIndex}>
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
          icon={<InputIcon />}
          onTouchTap={() => dispatch(push('/submit'))}
        />
      </BottomNavigation>
    );
  }
}

export default connect(state => ({
  location: state.router.location
}))(BottomNav);
