import Store from './store'
import _extend from 'lodash/extend'

let _reports

let ReportsStore = _extend({}, Store, {
  init (reports) {
    _reports = reports
  },

  all () {
    return _reports
  }
})

module.exports = ReportsStore
