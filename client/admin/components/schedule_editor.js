import _map from 'lodash/map'
import _keys from 'lodash/keys'
import _find from 'lodash/find'
import _groupBy from 'lodash/groupBy'
import moment from 'moment'
import dateMath from 'date-arithmetic'
import React from 'react'
import {Tabs, Tab} from 'react-bootstrap'
import TimeColumn from './time_column'
import GamesStore from '../stores/games_store'

class ScheduleEditor extends React.Component {
  constructor (props) {
    super(props)

    let games = JSON.parse(this.props.games)
    GamesStore.init(games)

    this.fields = JSON.parse(this.props.fields)

    this.gameWidth = 70
    this.now = new Date(Date.now())
    this.min = new Date(2016, 10, 5, 9)
    this.max = new Date(2016, 10, 5, 17)
    this.step = 10
    this.timeslots = 6
    this.totalMin = dateMath.diff(this.min, this.max, 'minutes')

    this.renderDivisionTab = this.renderDivisionTab.bind(this)
    this.renderGamesRow = this.renderGamesRow.bind(this)
    this.renderUnscheduledGame = this.renderUnscheduledGame.bind(this)
    this.renderScheduledGame = this.renderScheduledGame.bind(this)
    this.renderFieldColumn = this.renderFieldColumn.bind(this)
    this.renderGameText = this.renderGameText.bind(this)
    this.onChange = this.onChange.bind(this)

    let gamesByGroup = _groupBy(GamesStore.all(), 'scheduled')

    this.state = {
      unscheduledGames: gamesByGroup[false],
      scheduledGames: gamesByGroup[true]
    }
  }

  componentDidMount () {
    GamesStore.addChangeListener(this.onChange)
  }

  componentWillUnmount () {
    GamesStore.removeChangeListener(this.onChange)
  }

  onChange () {
    let gamesByGroup = _groupBy(GamesStore.all(), 'scheduled')

    this.setState({
      unscheduledGames: gamesByGroup[false],
      scheduledGames: gamesByGroup[true]
    })
  }

  render () {
    return (
      <div>
        <div style={{paddingBottom: '10px'}}>
          {this.renderUnscheduled()}
        </div>
        {this.renderSchedule()}
      </div>
    )
  }

  renderUnscheduled () {
    let games = this.state.unscheduledGames
    let gameByDivision = _groupBy(games, 'division')

    return (
      <div style={{paddingLeft: '5px'}}>
        <Tabs id="divisions">
          {_map(gameByDivision, this.renderDivisionTab)}
        </Tabs>
      </div>
    )
  }

  renderDivisionTab (games, divisionName) {
    let poolGames = games.filter((g) => { return g.pool })
    let bracketGames = games.filter((g) => { return g.bracket })

    let poolGamesByRound = _groupBy(poolGames, 'round')
    let poolRounds = _keys(poolGamesByRound).sort()

    let bracketGamesByRound = _groupBy(bracketGames, 'round')
    let bracketRounds = _keys(bracketGamesByRound).sort()

    return (
      <Tab key={divisionName} eventKey={divisionName} title={divisionName}>
        {_map(poolRounds, (round) => {
          return this.renderGamesRow('pool', round, poolGamesByRound[round])
        })}
        {_map(bracketRounds, (round) => {
          return this.renderGamesRow('bracket', round, bracketGamesByRound[round])
        })}
      </Tab>
    )
  }

  renderGamesRow (stage, round, games) {
    return (
      <div key={stage + round} style={{display: 'flex'}}>
        {_map(games, this.renderUnscheduledGame)}
      </div>
    )
  }

  renderUnscheduledGame (game) {
    let style = {
      width: '65px',
      height: '60px',
      margin: '5px',
      border: '1px solid',
      backgroundColor: '#a6cee3',
      textAlign: 'center'
    }

    return (
      <div key={game.id} style={style} draggable>
        {this.renderGameText(game)}
      </div>
    )
  }

  renderSchedule () {
    let fields = this.fields

    return (
      <div style={{display: 'flex'}}>
        { this.renderLabelsColumn() }
        { _map(fields, this.renderFieldColumn) }
      </div>
    )
  }

  renderLabelsColumn () {
    return (<TimeColumn
      key={'labels'}
      now={this.now}
      min={this.min}
      max={this.max}
      step={this.step}
      timeslots={this.timeslots}
      showLabels={true}
      rowHeight={10}
      colWidth={80}
    />)
  }

  renderFieldColumn (field, idx) {
    let games = this.state.scheduledGames || []
    games = games.filter((g) => g.field_id === field.id)

    return (
      <div key={field.id}>
        <TimeColumn
          field={field.id}
          title={field.name}
          now={this.now}
          min={this.min}
          max={this.max}
          step={this.step}
          timeslots={this.timeslots}
          rowHeight={10}
          colWidth={70}
        >
          { _map(games, this.renderScheduledGame) }
        </TimeColumn>
      </div>
    )
  }

  // I need this DayColumn thing so that I overlay at the right level.
  renderScheduledGame (game) {
    let field = _find(this.fields, (f) => f.id === game.field_id)
    let startSlot = dateMath.diff(this.min, new Date(game.start_time), 'minutes')
    let endSlot = dateMath.diff(this.min, new Date(game.end_time), 'minutes')

    let top = ((startSlot / this.totalMin) * 100)
    let bottom = ((endSlot / this.totalMin) * 100)

    let style = {
      position: 'relative',
      top: top + '%',
      height: bottom - top + '%',
      width: '65px'
    }

    return (
      <div key={game.id} style={style}>
        {field.name}
        {moment(game.start_time).format('hh:mm A')}
      </div>
    )
  }

  renderGameText (game) {
    if (game.bracket) {
      return (
        <div>
          <h4>{game.bracket_uid}</h4>
          {game.home_prereq} v {game.away_prereq}
        </div>
      )
    } else {
      return (
        <div>
          <h4>{game.pool}</h4>
          {game.home_pool_seed} v {game.away_pool_seed}
        </div>
      )
    }
  }
}

module.exports = ScheduleEditor
