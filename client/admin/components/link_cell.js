import React from 'react';
import ReactDOM from 'react-dom';

class LinkCell extends React.Component {
  render() {
    let obj = this.props.rowData;
    let path = obj.path;
    return <a href={path}>{this.props.data}</a>;
  }
}

module.exports = LinkCell;
