class Admin.GamesTable

  constructor: ->

  updateScore: (form, refreshKey) ->
    @_startLoading(form)
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      dataType: 'json'
      success: (response) =>
        node = $(form).parents('td').find('a')
        node.text("#{response.home_score} - #{response.away_score}")
        @_finishLoading(form)
        Admin.Flash.notice('Score updated')
        popover = $(form).parents('.popover')
        popover.popoverX('hide')
      error: (response) =>
        @_finishLoading(form)
        Admin.Flash.error('Error updating score')

  _startLoading: (form) ->
    Turbolinks.ProgressBar.start()
    $(form).find(':submit').addClass('is-loading')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $(form).find(':submit').removeClass('is-loading')
