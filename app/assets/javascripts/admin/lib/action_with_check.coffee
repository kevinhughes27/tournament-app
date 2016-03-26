Admin.ActionWithCheck = (url, method, confirmed = false, form = null) ->
  data = if form then $(form).serialize() else {confirm: confirmed}

  $.ajax
    type: method
    url: url
    data: data
    dataType: 'html'
    error: (response) ->
      modalContent = response.responseText
      $modal = $('#confirmActionModal')
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
