var Store = require('./store');

var _fields;

var FieldsStore = _.extend({}, Store, {
  init(fields){
    _fields = fields;
  },

  all(){
    return _fields;
  }
});

module.exports = FieldsStore;
