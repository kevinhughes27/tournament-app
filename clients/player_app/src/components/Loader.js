import React, { Component } from 'react';
import { connect } from 'react-redux';
import Layout from './Layout';
import CircularProgress from '@material-ui/core/CircularProgress';
import { loadApp } from '../actions/load';

const pollingInterval = 5 * 60 * 1000 // 5 minutes in milliseconds

class Loader extends Component {
  componentDidMount() {
    this.load();
    setInterval(this.load, pollingInterval);
  }

  load = () => {
    this.props.dispatch(loadApp());
  }

  render() {
    const { loading, children } = this.props;

    if (loading) {
      return (
        <Layout>
          <div className="center">
            <CircularProgress size={80} />
          </div>
        </Layout>
      );
    } else {
      return (
        <Layout>
          {children}
        </Layout>
      );
    }
  }
}

export default connect(state => ({
  loading: state.loading,
  location: state.router.location
}))(Loader);
