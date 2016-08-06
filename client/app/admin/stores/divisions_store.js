var Store = require('./store');

var _divisions;

var DivisionsStore = _.extend({}, Store, {
  init(divisions){
    _divisions = divisions;
  },

  all(){
    return _divisions;
  }
});

module.exports = DivisionsStore;
