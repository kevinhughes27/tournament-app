Admin.DeleteWithCheck = (url, confirmed = false) ->
  $.ajax
    type: 'DELETE'
    url: url
    data: {confirm: confirmed}
    error: (response) ->
      message = response.responseJSON.message
      $('#confirmDeleteModal').find('#message').text(message)
      $('#confirmDeleteModal').modal('show')
    success: (response) ->
      eval(response)
