var _ = require('underscore'),
    React = require('react'),
    squish = require('object-squish'),
    queryString = require('query-string'),
    setQuery = require('set-query-string'),
    FormGroup = require('react-bootstrap').FormGroup,
    InputGroup = require('react-bootstrap').InputGroup,
    FormControl = require('react-bootstrap').FormControl,
    Dropdown = require('react-bootstrap').Dropdown,
    MenuItem = require('react-bootstrap').MenuItem,
    ButtonGroup = require('react-bootstrap').ButtonGroup,
    TeamsStore = require('../stores/teams_store'),
    LoadingMixin = require('../mixins/loading_mixin');

var FilterBar = {
  mixins: [LoadingMixin],

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

  performAction(action) {
    this._startLoading();
    var ids = _.map(TeamsStore.selected(), function(t) { return t.id });

    $.ajax({
      url: 'bulk_action',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        job: action.job,
        ids: ids,
        arg: action.arg
      },
      success: (response) => {
        this._finishLoading();
        _.each(response, function(team) { TeamsStore.updateTeam(team) });
        Admin.Flash.notice(action.success_msg);
      },
      error: (response) => {
        this._finishLoading();
        var message = response.responseJSON.message || action.failure_msg;
        Admin.Flash.error(message);
      }
    });
  },

  renderFiltersDropdown() {
    if (this.filters.length > 0) {
      return (
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
    }
  },

  renderBulkActionsDropdown() {
    if (this.bulkActions.length > 0 && TeamsStore.selected().length > 0) {
      return (
        <div className="input-group-btn">
          <Dropdown id="actions-dropdown">
            <Dropdown.Toggle>
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
    var searchValue = this.props.query.search;
    var currentFilters = _.omit(this.props.query, 'search');
    var filterNames = {};
    _.mapObject(currentFilters, (value, key) => {
      var f = _.find(this.filters, function(f) { return f.key == key && f.value == value });
      filterNames[key] = f.text;
    });

    return (
      <div className="filter-container" style={{paddingBottom: 10}}>
        <FormGroup>
          <InputGroup>
            {this.renderBulkActionsDropdown()}
            {this.renderFiltersDropdown()}
            <FormControl type="text"
               value={searchValue}
               name="search"
               placeholder="Search..."
               className="form-control"
               onChange={this.searchChange} />
          </InputGroup>
        </FormGroup>
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
