import React, { Component } from 'react';
import { connect } from 'react-redux';
import AppBar from 'material-ui/AppBar';
import Toolbar from 'material-ui/Toolbar';
import { withStyles } from 'material-ui/styles';
import SearchIcon from 'material-ui-icons/Search';
import AutoComplete from './AutoComplete';
import Typography from 'material-ui/Typography';

const styles = {
  root: {
    width: '100%'
  }
};

class TopBar extends Component {
  render() {
    const { teams = [], search, dispatch } = this.props;
    const teamNames = teams.map(t => t.name);

    const classes = this.props.classes;

    return (
      <div className={classes.root}>
        <AppBar position="static">
          <Toolbar>
            <SearchIcon />
            <Typography type="title" color="inherit">
              <AutoComplete
                value={search}
                placeholder="Search Teams"
                suggestions={teamNames}
                onChange={search => {
                  dispatch({ type: 'SET_SEARCH', value: search });
                }}
              />
            </Typography>
          </Toolbar>
        </AppBar>
      </div>
    );
    // return (
    //   <AppBar position="static">
    //     <Toolbar disableGutters>
    //       <SearchIcon />
    //
    //     </Toolbar>
    //   </AppBar>
    // );
  }
}

export default withStyles(styles)(
  connect(state => ({
    teams: state.app.teams,
    search: state.app.search
  }))(TopBar)
);
