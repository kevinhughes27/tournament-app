import React from 'react'
import UpdateScoreModal from './UpdateScoreModal'

class ScoreDispute extends React.Component {
  render () {
    let game = this.props.game

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
    )
  }
}

module.exports = ScoreDispute
