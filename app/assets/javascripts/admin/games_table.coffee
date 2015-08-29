class Admin.GamesTable

  constructor: ->
    $('.popover').on 'shown.bs.modal', (e) ->
      $(e.target).find('#home_score').focus()

    @_initGamesList()

  _initGamesList: ->
    @gamesList = new List('games', {
      valueNames: [
        'name',
        'division',
        'score',
        'submitted-by',
        'submitted-at',
        'confirmed',
        'comments'
      ]
    })

  _resetGamesList: ->
    $('#games > .search').unbind()
    $('#games > .sort').unbind()
    delete @gamesList
    @_initGamesList()

  updateScore: (form) ->
    @_startLoading(form)
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      success: (response) =>
        eval(response)
        @_resetGamesList()
        @_finishLoading(form)
        Admin.Flash.notice('Score updated')
      error: (response) =>
        eval(response)
        @_resetGamesList()
        @_finishLoading(form)
        Admin.Flash.error('Error updating score')

  _startLoading: (form) ->
    Turbolinks.ProgressBar.start()
    $(form).find(':submit').addClass('is-loading')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $(form).find(':submit').removeClass('is-loading')
