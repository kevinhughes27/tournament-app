var React = require('react'),
    ReactDOM = require('react-dom');

var LinkCell = React.createClass({
  render() {
    var obj = this.props.rowData;
    var path = obj.path;
    return <a href={path}>{this.props.data}</a>;
  }
});

module.exports = LinkCell;
