import React from 'react'
import {Collapse} from 'react-bootstrap'
import classNames from 'classnames'
import ScoreReports from './ScoreReports'
import ScoreDispute from './ScoreDispute'
import UpdateScoreModal from './UpdateScoreModal'
import GamesStore from '../../stores/GamesStore'

export class NameCell extends React.Component {
  constructor (props) {
    super(props)

    this.toggleCollapse = this.toggleCollapse.bind(this)

    let game = this.props.rowData
    this.state = { reportsOpen: game.reportsOpen || false }
  }

  toggleCollapse (e) {
    e.nativeEvent.preventDefault()
    let game = this.props.rowData
    let state = !this.state.reportsOpen

    GamesStore.saveReportsState(game, state)
    this.setState({ reportsOpen: state })
  }

  renderReportsBadge (game) {
    let badgeText
    let reportCount = game.score_reports.length

    // if the game is not confirmed but there is a report
    // then we know we need 2 reports
    if (game.confirmed) {
      badgeText = reportCount
    } else {
      badgeText = `${reportCount} / 2`
    }

    return (
      <span className='badge'>
        {badgeText}
      </span>
    )
  }

  renderDisputeBadge (game) {
    if (!game.has_dispute) {
      return
    }

    return (
      <i className='fa fa-lg fa-exclamation-triangle' style={{color: 'orange'}}></i>
    )
  }

  renderBadges (game) {
    return (
      <span>{this.renderReportsBadge(game)} {this.renderDisputeBadge(game)}
      </span>
    )
  }

  renderDispute (game) {
    if (!game.has_dispute) {
      return
    }

    return (
      <ScoreDispute game={game}/>
    )
  }

  render () {
    let game = this.props.rowData
    let reports = game.score_reports

    let nameClasses = classNames({'subdued': !game.one_team_present})
    let text = `${game.home_name} vs ${game.away_name}`

    if (reports.length === 0) {
      return (<span className={nameClasses}>{text}</span>)
    }

    return (
      <div>
        <a href="#" onClick={this.toggleCollapse}>
          <span>{text} {this.renderBadges(game)}</span>
        </a>
        <Collapse in={this.state.reportsOpen}>
          <div>
            <ScoreReports reports={reports}/>
            {this.renderDispute(game)}
          </div>
        </Collapse>
      </div>
    )
  }
}

export class ScoreCell extends React.Component {
  render () {
    let game = this.props.rowData

    if (!game.teams_present) {
      return (<div></div>)
    }

    let text
    if (game.confirmed) {
      text = `${game.home_score} - ${game.away_score}`
    } else {
      text = <i className="fa fa-pencil"></i>
    }

    return (
      <UpdateScoreModal game={game}
                        linkText={text}
                        linkClass="btn-inline"/>
    )
  }
}
