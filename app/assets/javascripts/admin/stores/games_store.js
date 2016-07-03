var Store = require('./store');

var _games;
var _cable;

var GamesStore = _.extend({}, Store, {
  init(games){
    _games = games;

    _cable = UT.cable.subscriptions.create("GamesChannel", {
      received: function(data) {
        var game = JSON.parse(data);
        var scroll = window.scrollY;
        GamesStore.updateGame(game);
        window.scrollTo(0, scroll);
      }
    });
  },

  all(){
    return _games;
  },

  saveReportsState(game, state) {
    var idx = findGameIdx(game);
    _games[idx].reportsOpen = state;
  },

  updateGame(game) {
    var idx = findGameIdx(game);
    if(idx == -1) { return; }

    if(_games[idx].has_dispute && !game.has_dispute) {
      updateSidebarBadge();
    }

    if(!_games[idx].confirmed && game.confirmed) {
      updateSidebarBadge();
    }

    _.extend(_games[idx], game);
    this.emitChange();
  }
});

var findGameIdx = function(game) {
  var idx = _.findIndex(_games, function(g) {
    return g.id == game.id;
  });

  return idx;
};

var updateSidebarBadge = function() {
  var $node = $('#games-badge');
  var count = parseInt($node.text());
  count = count - 1;
  if(count == 0) {
    $node.hide();
  } else {
    $node.text(count);
  }
};

module.exports = GamesStore;
