class Admin.BracketEditor

  constructor: ->

  saveBracket: (form, refreshKey) ->
    Turbolinks.ProgressBar.start()
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      success: (response) ->
         Turbolinks.replace(response, change: [refreshKey])
         Turbolinks.ProgressBar.done()
