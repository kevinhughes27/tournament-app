import React from 'react'
import PropTypes from 'prop-types'
import { DropTarget } from 'react-dnd'
import { ItemTypes } from './Constants'

import XLabels from './XLabels'
import YLabels from './YLabels'
import FieldColumn from './FieldColumn'
import _map from 'lodash/map'

const target = {
  drop (props, monitor) {
    const game = monitor.getItem()
    const { x, y } = monitor.getClientOffset()
    // convert x ,y to field and start time
    debugger
  }
}

function collect (connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver()
  }
}

class Schedule extends React.Component {
  render () {
    const { connectDropTarget, isOver, fields } = this.props
    const style = {
      opacity: isOver ? 0.5 : 1,
      cursor: 'move'
    }

    return connectDropTarget(
      <div className='schedule-editor' style={style}>
        <XLabels fields={fields} />
        <div className='body'>
          <YLabels />
          <div className='grid'>
            {_map(fields, (f) => {
              return <FieldColumn key={f.name} fieldId={f.id}/>
            })}
          </div>
        </div>
      </div>
    )
  }

}

Schedule.propTypes = {
  games: PropTypes.array.isRequired, // this is not used in this component..? Games are fetched from the store in FieldColumn
  fields: PropTypes.array.isRequired,
  connectDropTarget: PropTypes.func.isRequired,
  isOver: PropTypes.bool.isRequired
}

export default DropTarget(ItemTypes.GAME, target, collect)(Schedule)
