import Store from './store';
import _extend from 'lodash/extend';

let _fields;

let FieldsStore = _extend({}, Store, {
  init(fields){
    _fields = fields;
  },

  all(){
    return _fields;
  }
});

module.exports = FieldsStore;
