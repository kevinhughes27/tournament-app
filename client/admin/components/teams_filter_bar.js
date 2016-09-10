import FilterBar from './filter_bar';
import TeamsStore from '../stores/teams_store';
import _assign from 'lodash/assign';
import _each from 'lodash/each';
import _map from 'lodash/map';

let TeamsFilterBar = _assign({}, FilterBar, {

  getInitialState() {
    return {
      isLoading: false
    };
  },

  showBulkActions() {
    return this.bulkActions.length > 0 && TeamsStore.selected().length > 0
  },

  performAction(action) {
    this.setState({isLoading: true});
    let ids = _map(TeamsStore.selected(), function(t) { return t.id });

    $.ajax({
      url: 'bulk_action',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        action_class: action.action_class,
        ids: ids,
        arg: action.arg
      },
      success: (response) => {
        this.setState({isLoading: false});
        _each(response, function(team) { TeamsStore.updateTeam(team) });
        Admin.Flash.notice(action.success_msg);
      },
      error: (response) => {
        this.setState({isLoading: false});
        let message = response.responseJSON.message || action.failure_msg;
        Admin.Flash.error(message);
      }
    });
  }
});

module.exports = TeamsFilterBar
