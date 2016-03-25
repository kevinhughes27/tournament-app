var Store = require('./store');

var _teams;

var TeamsStore = _.extend({}, Store, {
  init(teams) {
    _teams = teams;
  },

  all() {
    return _teams;
  },

  selected() {
    return _.filter(_teams, function(t) { return t.selected });
  },

  saveSelectedState(team, state) {
    var idx = this._findTeamIdx(team);
    _teams[idx].selected = state;
    this.emitChange();
  },

  setSelected(state) {
    _.each(_teams, function(t) {
      t.selected = state;
    });
    this.emitChange();
  },

  updateTeam(team) {
    var idx = this._findTeamIdx(team);
    _teams[idx] = team;
    this.emitChange();
  },

  _findTeamIdx(team) {
    var idx = _.findIndex(_teams, function(t) {
      return t.id == team.id;
    });

    return idx;
  }
});

module.exports = TeamsStore;
