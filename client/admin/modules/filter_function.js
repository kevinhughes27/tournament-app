import _filter from 'lodash/filter';
import _has from 'lodash/has';
import _indexOf from 'lodash/indexOf';
import squish from 'object-squish';

let filterFunction = function(results, filter) {
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
        let keyNotSearchable = _indexOf(this.searchColumns, key) == -1;
        if (keyNotSearchable) continue;

        if (String(flat[key]).toLowerCase().indexOf(search) >= 0) {
          return true;
        };
      };
      return false;
    }

    return true;
  });
};

module.exports = filterFunction
