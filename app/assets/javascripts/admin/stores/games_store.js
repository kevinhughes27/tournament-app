var Store = require('./store');

var _games;

var GamesStore = _.extend({}, Store, {
  init(games){
    _games = games;
  },

  all(){
    return _games;
  },

  updateGame(game) {
    var idx = _.findIndex(_games, function(g){
      return g.id == game.id;
    });

    _games[idx] = game;
    this.emitChange();
  }
});

module.exports = GamesStore;
