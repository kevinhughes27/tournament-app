var Store = require('./store');

var _teams;

var TeamsStore = _.extend({}, Store, {
  init(teams){
    _teams = teams;
  },

  all(){
    return _teams;
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
