var React = require('react'),
    classNames = require('classnames'),
    GamesStore = require('../stores/games_store'),
    LoadingMixin = require('../mixins/loading_mixin');

var ScoreDispute = React.createClass({
  mixins: [LoadingMixin],

  resolve() {
    var gameId = this.props.gameId;
    var disputeId = this.props.disputeId;

    $.ajax({
      url: 'games/' + gameId + "/disputes/" + disputeId,
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: (response) => {
        this._finishLoading();
        Admin.Flash.notice('Dispute resolved')
      },
      error: (response) => {
        this._finishLoading();
        Admin.Flash.error('Error resolving dispute');
      }
    })
  },

  render() {
    var btnClasses = classNames(
      'btn',
      'btn-primary',
      'pull-right',
      {'is-loading': this.state.isLoading}
    );

    return (
      <div className="alert alert-warning" style={{paddingBottom: '47px'}}>
        <h4>Score Dispute</h4>
        <p>
          Conflicting score reports have been received. You should check on what
          happened and then resolve this dispute.
        </p>
        <button className={btnClasses} onClick={this.resolve}>
          Resolve
        </button>
      </div>
    );
  }
});

module.exports = ScoreDispute;
