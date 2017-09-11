import React, { Component } from 'react';
import { connect } from 'react-redux';
import Layout from './Layout';
import Center from 'react-center';
import { CircularProgress } from 'material-ui/Progress';
import { loadApp } from '../actions/load';

class Loader extends Component {
  componentWillMount() {
    this.props.dispatch(loadApp());
  }

  render() {
    const { loading, children } = this.props;

    if (loading) {
      return (
        <Layout>
          <Center>
            <CircularProgress size={80} />
          </Center>
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
