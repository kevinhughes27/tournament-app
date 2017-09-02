import React, { Component } from 'react';
import { connect } from 'react-redux';
import Layout from './Layout';
import Center from 'react-center';
import CircularProgress from 'material-ui/CircularProgress';

class Loader extends Component {
  render() {
    const { loading, children } = this.props;

    if (loading) {
      return (
        <Layout>
          <Center>
            <CircularProgress size={80} thickness={5} />
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
  loading: state.app.loading,
  location: state.router.location
}))(Loader);
