$(document).ready ->
  $('form.new_user').on 'submit', (ev) ->
    ev.preventDefault()

    form = ev.target
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      dataType: 'json'
      success: (response) ->
        Turbolinks.visit('/setup')
      error: (response) ->
        # show errors
        debugger
