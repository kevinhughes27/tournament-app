import _filter from 'lodash/filter';
import _has from 'lodash/has';
import _indexOf from 'lodash/indexOf';
import squish from 'object-squish';

let FilterFunction = {
  componentDidMount() {
    if(!this.searchColumns) {
      this.searchColumns = []
      console.warn("FilterBarMixin included but searchColumns not defined. Include `searchColumns: [...]` in your component")
    };
  },

  filterFunction(results, filter) {
    return _filter(results, (item) => {
      // filter
      for(let key in filter) {
        if(key == 'search') continue;

        if(_has(filter, key)) {
          if(item[key] != filter[key]) {
            return false;
          }
        };
      };

      // search
      let flat = squish(item);
      let search = filter.search;
      if(search) {
        search = search.trim().toLowerCase();
        for (let key in flat) {
          if (this._keyNotSearchable(key)) continue;

          if (String(flat[key]).toLowerCase().indexOf(search) >= 0) {
            return true;
          };
        };
        return false;
      }

      return true;
    });
  },

  _keyNotSearchable(key) {
    return _indexOf(this.searchColumns, key) == -1;
  }
};

module.exports = FilterFunction
