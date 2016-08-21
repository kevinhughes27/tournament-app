import Store from './store';
import _extend from 'lodash/extend';

let _divisions;

let DivisionsStore = _extend({}, Store, {
  init(divisions){
    _divisions = divisions;
  },

  all(){
    return _divisions;
  }
});

module.exports = DivisionsStore;
