$.rails.ajax = (options) ->
  op = $.ajax(options)

  op.done (response) ->
    # if error
    unless response.substring(0, 16) == 'Turbolinks.visit'
      Turbolinks.replace(response)
      window.scroll(0,0)
