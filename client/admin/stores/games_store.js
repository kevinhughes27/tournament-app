import Store from './store';
import _extend from 'lodash/extend';
import _findIndex from 'lodash/findIndex';

let _games;
let _cable;

let GamesStore = _extend({}, Store, {
  init(games){
    _games = games;

    _cable = UT.cable.subscriptions.create("GamesChannel", {
      received: function(data) {
        let game = JSON.parse(data);
        let scroll = window.scrollY;
        GamesStore.updateGame(game);
        window.scrollTo(0, scroll);
      }
    });
  },

  all(){
    return _games;
  },

  saveReportsState(game, state) {
    let idx = findGameIdx(game);
    _games[idx].reportsOpen = state;
  },

  updateGame(game) {
    let idx = findGameIdx(game);
    if(idx == -1) { return; }

    if(_games[idx].has_dispute && !game.has_dispute) {
      updateSidebarBadge();
    }

    if(!_games[idx].confirmed && game.confirmed) {
      updateSidebarBadge();
    }

    _extend(_games[idx], game);
    this.emitChange();
  }
});

let findGameIdx = function(game) {
  let idx = _findIndex(_games, function(g) {
    return g.id == game.id;
  });

  return idx;
};

let updateSidebarBadge = function() {
  let $node = $('#games-badge');
  let count = parseInt($node.text());
  count = count - 1;
  if(count == 0) {
    $node.hide();
  } else {
    $node.text(count);
  }
};

module.exports = GamesStore;
