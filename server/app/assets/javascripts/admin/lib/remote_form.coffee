$.rails.ajax = (options) ->
  op = $.ajax(options)

  op.done (response) ->
    unless response.substring(0, 10) == 'Turbolinks'
      Turbolinks.replace(response)
      window.scroll(0,0)
