$.rails.ajax = (options) ->
  op = $.ajax(options)

  op.done (response) ->
    Turbolinks.replace(response) unless response.substring(0, 16) == 'Turbolinks.visit'
