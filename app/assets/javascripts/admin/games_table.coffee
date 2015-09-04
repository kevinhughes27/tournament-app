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

  updateScore: (form) ->
    @_startLoading(form)
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      success: (response) =>
        @gamesList.search()
        eval(response)
        @gamesList.reIndex()
        @_finishLoading(form)
        Admin.Flash.notice('Score updated')
      error: (response) =>
        @gamesList.search()
        eval(response)
        @gamesList.reIndex()
        @_finishLoading(form)
        Admin.Flash.error('Error updating score')

  _startLoading: (form) ->
    Turbolinks.ProgressBar.start()
    $(form).find(':submit').addClass('is-loading')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $('body').removeClass('modal-open')
    $(form).find(':submit').removeClass('is-loading')
