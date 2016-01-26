var _ = require('underscore'),
    squish = require('object-squish'),
    queryString = require('query-string'),
    setQuery = require('set-query-string'),
    Input = require('react-bootstrap').Input,
    Dropdown = require('react-bootstrap').Dropdown,
    MenuItem = require('react-bootstrap').MenuItem;

var FilterBar = {
  getDefaultProps() {
    return {
      "query": queryString.parse(location.search)
    }
  },

  componentDidMount() {
    if(!this.filters) {
      this.filters = []
      console.warn("FilterBar component used without filters. You may want to include `filters: [...]` in your component")
    };

    this.props.changeFilter(this.props.query);
  },

  componentWillReceiveProps() {
    setQuery(this.props.query, {clear: true});
  },

  searchChange(event) {
    var value = event.target.value;

    if(value == '') {
      delete this.props.query['search']
    } else {
      this.props.query['search'] = value;
    }

    this.props.changeFilter(this.props.query);
  },

  addFilter(filter) {
    this.props.query[filter.key] = filter.value;
    this.props.changeFilter(this.props.query);
  },

  deleteFilter(key) {
    delete this.props.query[key];
    this.props.changeFilter(this.props.query);
  },

  renderBar() {
    if(this.filters.length > 0) {
      return this._renderFilterSearchBar();
    } else {
      return this._renderSearchBar();
    }
  },

  _renderSearchBar() {
    var searchValue = this.props.query.search;

    return (
      <div className="filter-container" style={{paddingBottom: 10}}>
        <Input type="text"
               value={searchValue}
               name="search"
               placeholder="Search..."
               className="form-control"
               onChange={this.searchChange} />
      </div>
    );
  },

  _renderFilterSearchBar() {
    var searchValue = this.props.query.search;
    var filterDropdown = (
      <div className="input-group-btn">
        <Dropdown id="filter-dropdown">
          <Dropdown.Toggle>
            Filter
          </Dropdown.Toggle>
          <Dropdown.Menu style={{boxShadow: '0 6px 12px rgba(0, 0, 0, 0.175)'}}>
            {this.filters.map((f, i) => {
              return (
                <MenuItem key={i} onClick={() => this.addFilter(f)}>
                  <i className="fa fa-circle"></i>
                  {f.text}
               </MenuItem>
             );
            })}
          </Dropdown.Menu>
        </Dropdown>
      </div>
    );

    var currentFilters = _.omit(this.props.query, 'search');
    var filterNames = {};
    _.mapObject(currentFilters, (value, key) => {
      var f = _.find(this.filters, function(f) { return f.key == key && f.value == value });
      filterNames[key] = f.text;
    });

    return (
      <div className="filter-container" style={{paddingBottom: 10}}>
        <Input type="text"
               value={searchValue}
               name="search"
               placeholder="Search..."
               className="form-control"
               onChange={this.searchChange}
               buttonBefore={filterDropdown} />
        <div className="btn-toolbar">
          { _.keys(currentFilters).map((key, idx) => {
            return <Filter
              key={idx}
              filterKey={key}
              filterText={filterNames[key]}
              filterValue={currentFilters[key]}
              deleteFilter={this.deleteFilter} />;
          })}
        </div>
      </div>
    );
  }
};

var Filter = React.createClass({
  clickHandler() {
    var filterKey = this.props.filterKey;
    this.props.deleteFilter(filterKey);
  },

  render() {
    return (
      <button className="btn btn-xs btn-info" onClick={this.clickHandler}>
        <span>{this.props.filterText} </span>
        <i className="fa fa-close"></i>
      </button>
    );
  }
});

module.exports = FilterBar;
