var _ = require('underscore'),
    squish = require('object-squish');

var FilterBarMixin = {
  filterFunction(results, filter) {
    return _.filter(results, (item) => {
      // filter
      for(key in filter) {
        if(key == 'search') continue;

        if(filter[key]) {
          if(item[key] != filter[key]) {
            return false;
          }
        };
      };

      // search
      var flat = squish(item);
      var search = filter.search;
      if(search) {
        for (var key in flat) {
          if (this._keyNotSearchable(key)) continue;

          if (String(flat[key]).toLowerCase().indexOf(search.toLowerCase()) >= 0) {
            return true;
          };
        };
        return false;
      }

      return true;
    });
  },

  _keyNotSearchable(key) {
    // parten must implement
    var searchColumns = this.searchColumns()
    return _.indexOf(searchColumns, key) == -1
  }
};

module.exports = FilterBarMixin
