import React from 'react'
import UnscheduledGames from './UnscheduledGames'
import Schedule from './Schedule'
import GamesStore from '../../stores/GamesStore'

class ScheduleEditor extends React.Component {
  constructor (props) {
    super(props)

    GamesStore.init(JSON.parse(this.props.games))

    this.onChange = this.onChange.bind(this)

    this.state = {
      unscheduledGames: GamesStore.unscheduled(),
      scheduledGames: GamesStore.scheduled()
    }
  }

  componentDidMount () {
    GamesStore.addChangeListener(this.onChange)
  }

  componentWillUnmount () {
    GamesStore.removeChangeListener(this.onChange)
  }

  onChange () {
    this.setState({
      unscheduledGames: GamesStore.unscheduled(),
      scheduledGames: GamesStore.scheduled()
    })
  }

  render () {
    let unscheduledGames = this.state.unscheduledGames
    let scheduledGames = this.state.scheduledGames
    let fields = JSON.parse(this.props.fields)

    return (
      <div>
        <div style={{paddingBottom: '10px'}}>
          <UnscheduledGames games={unscheduledGames}/>
        </div>
        <div style={{minHeight: '400px'}}>
          <Schedule games={scheduledGames} fields={fields}/>
        </div>
      </div>
    )
  }
}

ScheduleEditor.propTypes = {
  games: React.PropTypes.string.isRequired,
  fields: React.PropTypes.string.isRequired
}

module.exports = ScheduleEditor
