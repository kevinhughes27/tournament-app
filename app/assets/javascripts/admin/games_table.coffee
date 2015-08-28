class Admin.GamesTable

  constructor: ->
    Twine.afterBound =>
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

  openScoreForm: (node) ->
    _.defer -> $(node.parentNode).find('#home_score').focus()

  updateScore: (form) ->
    @_startLoading(form)
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      success: (response) =>
        eval(response)
        @_finishLoading(form)
        Admin.Flash.notice('Score updated')
      error: (response) =>
        eval(response)
        @_finishLoading(form)
        Admin.Flash.error('Error updating score')

  _startLoading: (form) ->
    Turbolinks.ProgressBar.start()
    $(form).find(':submit').addClass('is-loading')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $(form).find(':submit').removeClass('is-loading')
