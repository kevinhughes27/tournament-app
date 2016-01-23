var _ = require('underscore'),
    squish = require('object-squish'),
    Input = require('react-bootstrap').Input,
    Dropdown = require('react-bootstrap').Dropdown,
    MenuItem = require('react-bootstrap').MenuItem;

var FilterBar = {
  getDefaultProps() {
    return {
      "query": { "search" : ""}
    }
  },

  componentDidMount() {
    if(!this.filters) {
      this.filters = []
      console.warn("FilterBar component used without filters. You may want to include `filters: [...]` in your component")
    };

    this.props.changeFilter(this.props.query);
  },

  searchChange(event) {
    this.props.query['search'] = event.target.value;
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
    return (
      <div className="filter-container" style={{paddingBottom: 10}}>
        <Input type="text"
               name="search"
               placeholder="Search..."
               className="form-control"
               onChange={this.searchChange} />
      </div>
    );
  },

  _renderFilterSearchBar() {
    var filterDropdown = (<FilterBuilder filters={this.filters} addFilter={this.addFilter}/>);
    var currentFilters = _.omit(this.props.query, 'search');
    var filterNames = {};
    _.mapObject(currentFilters, (value, key) => {
      var f = _.find(this.filters, function(f) { return f.key == key && f.value == value });
      filterNames[key] = f.text;
    });

    return (
      <div className="filter-container" style={{paddingBottom: 10}}>
        <Input type="text"
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

var FilterBuilder = React.createClass({
  render() {
    var filters = this.props.filters;
    var addFilter = this.props.addFilter
    return(
      <div className="input-group-btn">
        <Dropdown id="filter-dropdown">
          <Dropdown.Toggle>
            Filter
          </Dropdown.Toggle>
          <Dropdown.Menu style={{boxShadow: '0 6px 12px rgba(0, 0, 0, 0.175)'}}>
            {filters.map((f, i) => {
              return (
                <MenuItem key={i} onClick={() => addFilter(f)}>
                  <i className="fa fa-filter"></i>
                  {f.text}
               </MenuItem>
             );
            })}
          </Dropdown.Menu>
        </Dropdown>
      </div>
    );
  }
});

var Filter = React.createClass({
  clickHandler() {
    var filterKey = this.props.filterKey;
    this.props.deleteFilter(filterKey);
  },

  render() {
    return (
      <button className="btn btn-xs btn-info" onClick={this.clickHandler}>
        <span>{this.props.filterText}</span>
        <i className="fa fa-close"></i>
      </button>
    );
  }
});

module.exports = FilterBar;
