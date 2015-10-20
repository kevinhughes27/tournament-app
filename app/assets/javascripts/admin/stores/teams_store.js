var Store = require('./store');

var _teams;

var TeamsStore = _.extend({}, Store, {
  init(teams){
    _teams = teams;
  },

  all(){
    return _teams;
  }
});

module.exports = TeamsStore;
