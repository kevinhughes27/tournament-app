var LoadingMixin = {
  getInitialState() {
    return {
      isLoading: false
    };
  },

  _startLoading() {
    Turbolinks.ProgressBar.start()
    this.setState({isLoading: true});
  },

  _finishLoading() {
    Turbolinks.ProgressBar.done()
    this.setState({isLoading: false});
  }
};

module.exports = LoadingMixin;
