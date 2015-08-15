class Admin.BracketEditor

  constructor: ->

  saveBracket: (form, refreshKey) ->
    @_startLoading(form)
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      success: (response) =>
         Turbolinks.replace(response, change: [refreshKey])
         @_finishLoading(form)

  seedBracket: ($node, path) ->
    Turbolinks.ProgressBar.start()
    $node.addClass('is-loading')

    $.ajax
      type: 'PUT'
      url: path
      success: (response) ->
        Turbolinks.ProgressBar.done()
        $node.removeClass('is-loading')

  _startLoading: (form) ->
    Turbolinks.ProgressBar.start()
    $(form).find(':submit').addClass('is-loading')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $(form).find(':submit').removeClass('is-loading')
