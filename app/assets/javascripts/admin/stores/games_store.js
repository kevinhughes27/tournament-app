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

    if(!_games[idx].confirmed && game.confirmed) {
      this._updateSidebarBadge();
    }

    _games[idx] = game;
    this.emitChange();
  },

  _findGameIdx(game) {
    var idx = _.findIndex(_games, function(g) {
      return g.id == game.id;
    });

    return idx;
  },

  _updateSidebarBadge() {
    var $node = $('#games-badge');
    var count = parseInt($node.text());
    count = count - 1;
    if(count == 0) {
      $node.hide();
    } else {
      $node.text(count);
    }
  }
});

module.exports = GamesStore;
