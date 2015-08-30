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

  _resetGamesList: (response) ->
    $searchNode = $('#games').find('.search')
    $sortNodes = $('#games').find('.sort')

    @gamesList.search()
    $searchNode.val('')
    $searchNode.unbind()
    $sortNodes.unbind()
    delete @gamesList

    eval(response)
    @_initGamesList()

  updateScore: (form) ->
    @_startLoading(form)
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      success: (response) =>
        @_resetGamesList(response)
        @_finishLoading(form)
        Admin.Flash.notice('Score updated')
      error: (response) =>
        @_resetGamesList(response)
        @_finishLoading(form)

        if response.status == 200
          Admin.Flash.notice('Score updated')
        else
          Admin.Flash.error('Error updating score')

  _startLoading: (form) ->
    Turbolinks.ProgressBar.start()
    $(form).find(':submit').addClass('is-loading')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $('body').removeClass('modal-open')
    $(form).find(':submit').removeClass('is-loading')
