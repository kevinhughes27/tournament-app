import _map from 'lodash/map';
import _each from 'lodash/each';
import _omit from 'lodash/omit';
import _forOwn from 'lodash/forOwn';
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

import TeamsStore from '../stores/teams_store';

let FilterBar = {
  getInitialState() {
    return {
      isLoading: false
    };
  },

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

  _onChange() {
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

  addFilter(filter) {
    this.props.query[filter.key] = filter.value;
    this.props.changeFilter(this.props.query);
  },

  deleteFilter(key) {
    delete this.props.query[key];
    this.props.changeFilter(this.props.query);
  },

  performAction(action) {
    this.setState({isLoading: true});
    let ids = _map(TeamsStore.selected(), function(t) { return t.id });

    $.ajax({
      url: 'bulk_action',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        action_class: action.action_class,
        ids: ids,
        arg: action.arg
      },
      success: (response) => {
        this.setState({isLoading: false});
        _each(response, function(team) { TeamsStore.updateTeam(team) });
        Admin.Flash.notice(action.success_msg);
      },
      error: (response) => {
        this.setState({isLoading: false});
        let message = response.responseJSON.message || action.failure_msg;
        Admin.Flash.error(message);
      }
    });
  },

  renderFiltersDropdown() {
    if (this.filters.length > 0) {
      return (
        <div className="input-group-btn">
          <Dropdown id="filter-dropdown">
            <Dropdown.Toggle style={{lineHeight: '1.42858'}}>
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
    }
  },

  renderBulkActionsDropdown() {
    if (this.bulkActions.length > 0 && TeamsStore.selected().length > 0) {
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
    }
  },

  renderBar() {
    let searchValue = this.props.query.search;
    let currentFilters = _omit(this.props.query, 'search');
    let filterNames = {};
    _forOwn(currentFilters, (value, key) => {
      let f = _find(this.filters, function(f) { return f.key == key && f.value == value });
      filterNames[key] = f.text;
    });

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
          { _keys(currentFilters).map((key, idx) => {
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

let Filter = React.createClass({
  clickHandler() {
    let filterKey = this.props.filterKey;
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
