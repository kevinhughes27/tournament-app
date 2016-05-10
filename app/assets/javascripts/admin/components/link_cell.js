var React = require('react');

var LinkCell = React.createClass({
  render() {
    var obj = this.props.rowData;
    var path = obj.path;
    return <a href={path}>{this.props.data}</a>;
  }
});

module.exports = LinkCell;
