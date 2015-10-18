var AppDispatcher = require('../dispatcher').AppDispatcher;
var EventEmitter = require('events').EventEmitter;

var _games;

var GamesStore = _.extend({}, EventEmitter.prototype, {

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
  },

  // Emit Change event
  emitChange() {
    this.emit('change');
  },

  // Add change listener
  addChangeListener(callback) {
    this.on('change', callback);
  },

  // Remove change listener
  removeChangeListener(callback) {
    this.removeListener('change', callback);
  }
});

module.exports = GamesStore;
