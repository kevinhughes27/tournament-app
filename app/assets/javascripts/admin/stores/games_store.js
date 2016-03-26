var Store = require('./store');

var _games;

var GamesStore = _.extend({}, Store, {
  init(games){
    _games = games;
  },

  all(){
    return _games;
  },

  saveReportsState(game, state) {
    var idx = this._findGameIdx(game);
    _games[idx].reportsOpen = state;
  },

  updateGame(game) {
    var idx = this._findGameIdx(game);
    _games[idx] = game;
    this.emitChange();
  },

  _findGameIdx(game) {
    var idx = _.findIndex(_games, function(g) {
      return g.id == game.id;
    });

    return idx;
  }
});

module.exports = GamesStore;
