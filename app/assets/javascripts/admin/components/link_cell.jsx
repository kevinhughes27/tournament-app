var React = require('react');

var LinkCell = React.createClass({
  render() {
    var obj = this.props.rowData;
    var url = obj.url;
    return <a href={url}>{this.props.data}</a>;
  }
});

module.exports = LinkCell;
