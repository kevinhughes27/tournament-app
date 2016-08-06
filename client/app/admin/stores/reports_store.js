var Store = require('./store');

var _reports;

var ReportsStore = _.extend({}, Store, {
  init(reports){
    _reports = reports;
  },

  all(){
    return _reports;
  }
});

module.exports = ReportsStore;
