import React, { Component } from 'react';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';
import BottomNavigation from '@material-ui/core/BottomNavigation';
import BottomNavigationAction from '@material-ui/core/BottomNavigationAction';
import EventIcon from '@material-ui/icons/Event';
import LocationIcon from '@material-ui/icons/LocationOn';
import InputIcon from '@material-ui/icons/Input';

class BottomNav extends Component {
  render() {
    const { location, dispatch } = this.props;

    const pathToIndex = {
      null: 0,
      '/': 0,
      '/map': 1,
      '/submit': 2
    };
    const value = pathToIndex[location.pathname];

    return (
      <BottomNavigation value={value} showLabels>
        <BottomNavigationAction
          label="Schedule"
          icon={<EventIcon />}
          onClick={() => dispatch(push('/'))}
        />
        <BottomNavigationAction
          label="Map"
          icon={<LocationIcon />}
          onClick={() => dispatch(push('/map'))}
        />
        <BottomNavigationAction
          label="Submit Scores"
          icon={<InputIcon />}
          onClick={() => dispatch(push('/submit'))}
        />
      </BottomNavigation>
    );
  }
}

export default connect(state => ({
  location: state.router.location
}))(BottomNav);
