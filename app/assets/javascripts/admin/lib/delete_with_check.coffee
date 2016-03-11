Admin.DeleteWithCheck = (url, confirmed = false) ->
  $.ajax
    type: 'DELETE'
    url: url
    data: {confirm: confirmed}
    dataType: 'html'
    error: (response) ->
      modalContent = response.responseText
      $modal = $('#confirmDeleteModal')
      $modal.html(modalContent)

      Twine.bind($modal[0])
      $(document).trigger('page:change')

      $modal.modal('show')
      $('.btn-danger').removeClass('is-loading')
    success: (response) ->
      eval(response)
