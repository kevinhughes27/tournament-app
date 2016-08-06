var React = require('react'),
    ReactDOM = require('react-dom'),
    UpdateScoreModal = require('./update_score_modal');

var ScoreDispute = React.createClass({
  render() {
    var game = this.props.game;

    return (
      <div className="alert alert-warning" style={{paddingBottom: '47px'}}>
        <h4>Score Dispute</h4>
        <p>
          Conflicting score reports have been received. You should check on what
          happened and then resolve this dispute.
        </p>
        <UpdateScoreModal game={game}
                          resolve={true}
                          linkText='Resolve'
                          linkClass='btn btn-primary pull-right'/>
      </div>
    );
  }
});

module.exports = ScoreDispute;
