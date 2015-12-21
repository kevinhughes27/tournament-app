var _ = require('underscore'),
    squish = require('object-squish'),
    React = require('react'),
    Griddle = require('griddle-react'),
    Input = require('react-bootstrap').Input,
    Popover = require('react-bootstrap').Popover,
    Overlay = require('react-bootstrap').Overlay,
    Collapse = require('react-bootstrap').Collapse,
    TeamsStore = require('../stores/teams_store');

var columns = [
  "name",
  "email",
  "sms",
  "division",
  "seed"
];

var searchColumns = [
  "name",
  "email",
  "sms",
  "division",
  "seed"
];

var filterColumns = [
  "division"
];

var LinkCell = React.createClass({
  render(){
    var team = this.props.rowData;
    var url = "teams/" + team.id;
    return <a href={url}>{this.props.data}</a>;
  }
});

var columnsMeta = [
  {
    columnName: "name",
    displayName: "Name",
    cssClassName: "table-link",
    order: 1,
    customComponent: LinkCell
  },
  {
    columnName: "email",
    displayName: "Email",
    cssClassName: "table-link",
    order: 2,
    sortable: false
  },
  {
    columnName: "sms",
    displayName: "SMS",
    cssClassName: "table-link",
    order: 3,
    sortable: false
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "table-link",
    order: 4
  },
  {
    columnName: "seed",
    displayName: "Seed",
    cssClassName: "table-link",
    order: 5
  },
];

var FilterBuilder = React.createClass({
  getInitialState() {
    return this.defaultState();
  },

  defaultState() {
    return {
      show: false,
      filterKey: '',
      showForm: false,
      filterValue: '',
    };
  },

  toggle() {
    this.setState({show: !this.state.show});
  },

  hide() {
    this.setState({ show: false });
  },

  filterSelectChanged(event) {
    var val = event.target.value

    this.setState({
      filterKey: val,
      showForm: val != ''
    })
  },

  handleKeyPress(event) {
    if (event.charCode==13) {
      this.createFilter()
    };
  },

  createFilter() {
    this.props.addFilter(
      this.state.filterKey,
      this.state.filterValue
    );

    this.setState( this.defaultState() );
  },

  render() {
    return(
      <div className="input-group-btn">
        <button ref="target" className="btn btn-default" onClick={this.toggle}>
          Filter  <span className="caret"></span>
        </button>

        <Overlay
          show={this.state.show}
          onHide={() => this.hide()}
          target={() => ReactDOM.findDOMNode(this.refs.target)}
          placement="bottom"
          rootClose={true}
        >
          <Popover id="filters" style={{width: 240}}>
            <Input type="select" onChange={this.filterSelectChanged}>
              <option value=''>Select a filter</option>
              { filterColumns.map((col, idx) => {
                return <option value={col} key={idx}>{col}</option>;
              })}
            </Input>

            <Collapse in={this.state.showForm}>
              <div>
                <p>is equal to:</p>
                <Input type="text"
                       value={this.state.filterValue}
                       onKeyPress={this.handleKeyPress}
                       onChange={ (e) => {
                         this.setState({filterValue: e.target.value})
                       }} />
                <button className="btn btn-primary" onClick={this.createFilter}>
                  Create filter
                </button>
              </div>
            </Collapse>

          </Popover>
        </Overlay>
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
      <div style={{paddingTop: 10}}>
        <button className="btn btn-xs btn-info" onClick={this.clickHandler}>
          <span>{this.props.filterKey} : {this.props.filterValue} </span>
          <i className="fa fa-close"></i>
        </button>
      </div>
    );
  }
});

var TeamsFilter = React.createClass({
  getDefaultProps() {
    return {
      "query": {}
    }
  },

  searchChange(event) {
    this.props.query['search'] = event.target.value;
    this.props.changeFilter(this.props.query);
  },

  addFilter(key, value) {
    this.props.query[key] = value;
    this.props.changeFilter(this.props.query);
  },

  deleteFilter(key) {
    delete this.props.query[key];
    this.props.changeFilter(this.props.query);
  },

  render() {
    var filters = _.omit(this.props.query, 'search');

    return (
      <div className="filter-container" style={{paddingBottom: 10}}>
        <div className="input-group">
          <FilterBuilder addFilter={this.addFilter}/>
          <input type="text"
                 name="search"
                 placeholder="Search..."
                 className="form-control"
                 onChange={this.searchChange} />
        </div>
          { _.keys(filters).map((key, idx) => {
            return <Filter
              key={idx}
              filterKey={key}
              filterValue={filters[key]}
              deleteFilter={this.deleteFilter} />;
          })}
      </div>
    );
  }
});

var TeamsIndex = React.createClass({
  getInitialState() {
    TeamsStore.init(this.props.teams);

    return {
      teams: TeamsStore.all(),
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
    _.indexOf(searchColumns, key) == -1
  },

  render() {
    var teams = this.state.teams;

    return (
      <Griddle
        results={teams}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        resultsPerPage={teams.length}
        showPager={false}
        useGriddleStyles={false}
        sortAscendingClassName="sort asc"
        sortAscendingComponent=""
        sortDescendingClassName="sort desc"
        sortDescendingComponent=""
        showFilter={true}
        useCustomFilterer={true}
        customFilterer={this.filterFunction}
        useCustomFilterComponent={true}
        customFilterComponent={TeamsFilter}
      />
    );
  }
});

module.exports = TeamsIndex;
