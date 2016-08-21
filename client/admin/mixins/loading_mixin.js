let LoadingMixin = {
  getInitialState() {
    return {
      isLoading: false
    };
  },

  _startLoading() {
    this.setState({isLoading: true});
  },

  _finishLoading() {
    this.setState({isLoading: false});
  }
};

module.exports = LoadingMixin;
