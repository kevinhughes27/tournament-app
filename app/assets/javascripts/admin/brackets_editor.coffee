class Admin.BracketEditor

  constructor: ->

  updateSeeds: (form, refreshKey) ->
    @_startLoading(form)
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      success: (response) =>
        Turbolinks.replace(response, change: [refreshKey])
        @_finishLoading(form)
        Admin.Flash.notice('Seeding update')
      error: (response) =>
        @_finishLoading(form)
        Admin.Flash.error(response.responseJSON.errors.join(', '))

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
        Admin.Flash.notice('Bracket saved')
      error: (response) =>
        @_finishLoading(form)
        Admin.Flash.error(response.responseJSON.errors.join(', '))

  _startLoading: (form) ->
    Turbolinks.ProgressBar.start()
    $(form).find(':submit').addClass('is-loading')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $(form).find(':submit').removeClass('is-loading')

  seedBracket: ($node, path) ->
    @_startSeeding($node)

    $.ajax
      type: 'PUT'
      url: path
      success: (response) =>
        @_finishSeeding($node)
        Admin.Flash.notice('Bracket seeded')
      error: (response) =>
        @_finishSeeding($node)
        Admin.Flash.error(response.responseJSON.error)

  _startSeeding: ($node) ->
    Turbolinks.ProgressBar.start()
    $node.addClass('is-loading')

  _finishSeeding: ($node) ->
    Turbolinks.ProgressBar.done()
    $node.removeClass('is-loading')
