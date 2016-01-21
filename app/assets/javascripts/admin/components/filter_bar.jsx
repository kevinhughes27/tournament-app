var _ = require('underscore'),
    squish = require('object-squish'),
    Input = require('react-bootstrap').Input,
    Popover = require('react-bootstrap').Popover,
    Overlay = require('react-bootstrap').Overlay,
    Collapse = require('react-bootstrap').Collapse;

var FilterBar = {

  getDefaultProps() {
    return {
      "query": { "search" : ""}
    }
  },

  componentDidMount() {
    if(!this.filterColumns) {
      this.filterColumns = []
      console.warn("FilterBar component used without filterColumns. Include `filterColumns: [...]` in your component")
    };

    this.props.changeFilter(this.props.query);
  },

  searchChange(event) {
    this.props.query['search'] = event.target.value;
    this.props.changeFilter(this.props.query);
  },

  addFilter(key, value) {
    this.props.query[key] = value.trim();
    this.props.changeFilter(this.props.query);
  },

  deleteFilter(key) {
    delete this.props.query[key];
    this.props.changeFilter(this.props.query);
  },

  renderBar() {
    var filters = _.omit(this.props.query, 'search');
    var filterPadding = _.isEmpty(filters) ? 0 : 10;

    return (
      <div className="filter-container" style={{paddingBottom: 10}}>
        <div className="input-group">
          <FilterBuilder filterColumns={this.filterColumns} addFilter={this.addFilter}/>
          <input type="text"
                 name="search"
                 placeholder="Search..."
                 className="form-control"
                 onChange={this.searchChange} />
        </div>
        <div className="btn-toolbar" style={{paddingTop: filterPadding}}>
          { _.keys(filters).map((key, idx) => {
            return <Filter
              key={idx}
              filterKey={key}
              filterValue={filters[key]}
              deleteFilter={this.deleteFilter} />;
          })}
        </div>
      </div>
    );
  }
};

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
    var filterColumns = this.props.filterColumns;

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
          rootClose={true}>
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
      <button className="btn btn-xs btn-info" onClick={this.clickHandler}>
        <span>{this.props.filterKey} : {this.props.filterValue} </span>
        <i className="fa fa-close"></i>
      </button>
    );
  }
});

module.exports = FilterBar;
