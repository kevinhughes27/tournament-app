import Store from './store';
import _extend from 'lodash/extend';
import _each from 'lodash/each';
import _filter from 'lodash/filter';
import _findIndex from 'lodash/findIndex';

let _teams;

let TeamsStore = _extend({}, Store, {
  init(teams) {
    _teams = teams;
  },

  all() {
    return _teams;
  },

  selected() {
    return _filter(_teams, function(t) { return t.selected });
  },

  saveSelectedState(team, state) {
    let idx = this._findTeamIdx(team);
    _teams[idx].selected = state;
    this.emitChange();
  },

  setSelected(state) {
    _each(_teams, function(t) {
      t.selected = state;
    });
    this.emitChange();
  },

  updateTeam(team) {
    let idx = this._findTeamIdx(team);
    _teams[idx] = team;
    this.emitChange();
  },

  _findTeamIdx(team) {
    let idx = _findIndex(_teams, function(t) {
      return t.id == team.id;
    });

    return idx;
  }
});

module.exports = TeamsStore;
