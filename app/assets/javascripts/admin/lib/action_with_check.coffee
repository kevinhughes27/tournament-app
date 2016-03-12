Admin.ActionWithCheck = (url, method, confirmed = false) ->
  $.ajax
    type: method
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
      $('.btn').removeClass('is-loading')
    success: (response) ->
      if response.substring(0, 16) == 'Turbolinks.visit'
        eval(response)
      else
        Turbolinks.replace(response)
