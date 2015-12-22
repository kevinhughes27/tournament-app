var _ = require('underscore'),
    squish = require('object-squish');

var FilterBarMixin = {
  componentDidMount() {
    if(!this.searchColumns) {
      this.searchColumns = []
      console.warn("FilterBarMixin included but searchColumns not defined. Include `searchColumns: [...]` in your component")
    };
  },

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
    return _.indexOf(this.searchColumns, key) == -1
  }
};

module.exports = FilterBarMixin
