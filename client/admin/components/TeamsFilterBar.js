import FilterBar from './FilterBar'
import TeamsStore from '../stores/TeamsStore'
import _assign from 'lodash/assign'
import _each from 'lodash/each'
import _map from 'lodash/map'

let TeamsFilterBar = _assign({}, FilterBar, {

  getInitialState () {
    return {
      isLoading: false
    }
  },

  showBulkActions () {
    return this.bulkActions.length > 0 && TeamsStore.selected().length > 0
  },

  performAction (action) {
    this.setState({isLoading: true})
    let ids = _map(TeamsStore.selected(), function (t) { return t.id })

    $.ajax({
      url: action.url,
      type: 'PUT',
      beforeSend: function (xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
      data: {
        ids: ids,
        arg: action.arg
      },
      success: (response) => {
        this.setState({isLoading: false})
        _each(response, function (team) { TeamsStore.updateTeam(team) })
        Admin.Flash.notice(action.success_msg)
      },
      error: (response) => {
        this.setState({isLoading: false})
        let message = response.responseJSON.error || action.failure_msg
        Admin.Flash.error(message)
      }
    })
  }
})

module.exports = TeamsFilterBar
