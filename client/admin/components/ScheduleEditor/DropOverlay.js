import React from 'react'
import PropTypes from 'prop-types'
import GameLayout from './GameLayout'

class DropOverlay extends React.Component {
  render () {
    const { startTime, endTime } = this.props
    const layout = new GameLayout({start_time: startTime, end_time: endTime})
    const style = {
      opacity: 0.5,
      backgroundColor: 'black',
      ...layout.inlineStyles()
    }

    return (
      <div className='game' style={style}></div>
    )
  }
}

DropOverlay.propTypes = {
  startTime: PropTypes.string.isRequired,
  endTime: PropTypes.string.isRequired
}

export default DropOverlay
