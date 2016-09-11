import _omit from 'lodash/omit';
import _toPairs from 'lodash/toPairs';
import _find from 'lodash/find';
import _keys from 'lodash/keys';

import React from 'react';
import squish from 'object-squish';
import queryString from 'query-string';
import setQuery from 'set-query-string';

import {
  FormGroup,
  InputGroup,
  FormControl,
  Dropdown,
  MenuItem
} from 'react-bootstrap';

let FilterBar = {

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

  filterChange() {
    this.props.changeFilter(this.props.query);
  },

  searchChange(event) {
    let value = event.target.value;

    if(value == '') {
      delete this.props.query['search']
    } else {
      this.props.query['search'] = value;
    }

    this.props.changeFilter(this.props.query);
  },

  showFilters() {
    return this.filters.length > 0
  },

  addFilter(filter) {
    this.props.query[filter.key] = filter.value;
    this.props.changeFilter(this.props.query);
  },

  deleteFilter(key) {
    delete this.props.query[key];
    this.props.changeFilter(this.props.query);
  },

  showBulkActions() {
    return false;
  },

  performAction(action) {
    throw "performAction called but is has not been implemented.\
          If your FilterBar has bulk actions it should\
          extend FilterBar and implement performAction"
  },

  renderFiltersDropdown() {
    if ( !this.showFilters() ) return;

    return (
      <div className="input-group-btn">
        <Dropdown id="filter-dropdown">
          <Dropdown.Toggle style={{lineHeight: '1.42858'}}>
            Filter
          </Dropdown.Toggle>
          <Dropdown.Menu style={{boxShadow: '0 6px 12px rgba(0, 0, 0, 0.175)'}}>
            {this.filters.map(this.renderFilterMenuItem)}
          </Dropdown.Menu>
        </Dropdown>
      </div>
    );
  },

  renderFilterMenuItem(filter, idx) {
    if (filter.hidden) return;

    return (
      <MenuItem key={idx} onClick={() => this.addFilter(filter)}>
        <i className="fa fa-circle"></i>
        {filter.text}
     </MenuItem>
    );
  },

  renderBulkActionsDropdown() {
    if ( !this.showBulkActions() ) return;

    return (
      <div className="input-group-btn">
        <Dropdown id="actions-dropdown">
          <Dropdown.Toggle style={{lineHeight: '1.42858'}}>
            Bulk Actions
          </Dropdown.Toggle>
          <Dropdown.Menu style={{boxShadow: '0 6px 12px rgba(0, 0, 0, 0.175)'}}>
            {this.bulkActions.map((a, i) => {
              return (
                <MenuItem key={i} onClick={() => this.performAction(a)}>
                  <i className="fa fa-circle"></i>
                  {a.text}
               </MenuItem>
             );
            })}
          </Dropdown.Menu>
        </Dropdown>
      </div>
    );
  },

  renderBar() {
    let searchValue = this.props.query.search;
    let currentFilters = _omit(this.props.query, 'search');

    return (
      <div className="filter-container" style={{paddingBottom: 10}}>
        <FormGroup>
          <InputGroup style={{width: '100%'}}>
            {this.renderBulkActionsDropdown()}
            {this.renderFiltersDropdown()}
            <FormControl type="text"
               value={searchValue}
               name="search"
               placeholder="Search..."
               className="form-control"
               style={{marginLeft: '-3px'}}
               onChange={this.searchChange} />
          </InputGroup>
        </FormGroup>
        <div className="btn-toolbar">
          { _toPairs(currentFilters).map(this.renderFilter)}
        </div>
      </div>
    );
  },

  renderFilter(pair, idx) {
    let [key, value] = pair;
    let filter = _find(this.filters, function(f) { return f.key == key && f.value == value });

    return (
      <Filter
        key={idx}
        filterKey={key}
        filterText={filter.text}
        filterValue={filter.value}
        deleteFilter={this.deleteFilter} />
    );
  }
};

class Filter extends React.Component {
  constructor(props) {
    super(props);
    this.clickHandler = this.clickHandler.bind(this);
  }

  clickHandler() {
    let filterKey = this.props.filterKey;
    this.props.deleteFilter(filterKey);
  }

  render() {
    return (
      <button className="btn btn-xs btn-info" onClick={this.clickHandler}>
        <span>{this.props.filterText} </span>
        <i className="fa fa-close"></i>
      </button>
    );
  }
}

module.exports = FilterBar;
