class Admin.ScheduleEditor
  constructor: (@timeCap) ->
    @$tableNode = $('.schedule-table > table')
    @editor = new Admin.ScheduleDnD()

  addRow: ->
    trs = @$tableNode.find('tr')
    tr = trs[trs.length - 1]
    tr = $(tr).clone()

    $tr = $(tr)
    lastTime = $tr.find('input').val()
    time = moment(lastTime).add(@timeCap, 'minutes').format('MM/DD/YYYY h:mm A')
    $tr.find('input').val(time)
    $tr.find('div.game').remove()

    @$tableNode.append(tr[0])
    Twine.bind()

  timeUpdated: (event) ->
    rowIdx = $(event.target).closest('tr').index()

    startTime = $(event.target).val()
    startTime = moment(startTime).format()

    games = $("[data-row-idx=#{rowIdx}]")
    games.attr('data-changed', true)
    games.attr('data-start-time', startTime)

  save: (form) ->
    @_startLoading(form)
    @_clearGameErrors()
    games = @_collectGames()
    @_save(form, games)

  _startLoading: (form) ->
    Turbolinks.ProgressBar.start()
    $(form).find(':submit').addClass('is-loading')

  _collectGames: ->
    games = _.filter $('.game'), (g) -> $(g).data('changed') == true
    games = _.map games, (g) ->
      {
        id: $(g).attr('data-game-id')
        field_id: $(g).attr('data-field-id')
        start_time: $(g).attr('data-start-time')
      }
    games

  _save: (form, games) ->
    $.ajax
      type: 'POST'
      url: form.action
      data: {games: games}
      error: (response) =>
        @_finishLoading(form)
        if response.status == 422
          @_addGameErrors(response.responseJSON.game_id)
          message = response.responseJSON.error
          message = message.replace('Validation failed: ', '')
          message = message.split(', ')[0]
          Admin.Flash.error(message, 6000)
        else
          Admin.Flash.error('Sorry, something went wrong.')
      success: (response) =>
        @_finishLoading(form)
        @_keepScroll( -> Turbolinks.replace(response))
        Admin.Flash.notice('Schedule saved')

  _keepScroll: (func) ->
    if node = $('#games-card')[0]
      scrollLeft1 = node.scrollLeft
      scrollTop1 = node.scrollTop
    node = $('#schedule-card')[0]
    scrollLeft2 = node.scrollLeft
    scrollTop2 = node.scrollTop

    func.call()

    if node = $('#games-card')[0]
      node.scrollLeft = scrollLeft1
      node.scrollTop = scrollTop1
    node = $('#schedule-card')[0]
    node.scrollLeft = scrollLeft2
    node.scrollTop = scrollTop2

  _addGameErrors: (game_id) ->
    $("[data-game-id=#{game_id}]").addClass('game-error')

  _clearGameErrors: ->
    $('.game').removeClass('game-error')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $(form).find(':submit').removeClass('is-loading')
