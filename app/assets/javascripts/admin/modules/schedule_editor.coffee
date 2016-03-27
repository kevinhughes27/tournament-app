class Admin.ScheduleEditor

  constructor: (@$tableNode, @timeCap) ->
    @initDraggable()
    @initDropzone()

  addRow: ->
    trs = @$tableNode.find('tr')
    tr = trs[trs.length - 1]
    tr = $(tr).clone()

    $tr = $(tr)
    lastTime = $tr.find('input').val()
    time = moment(lastTime).add(@timeCap, 'minutes').format('MM/DD/YYYY h:mm A')
    $tr.find('input').val(time)
    $tr.find('.datetimepicker').datetimepicker(Admin.DatePickerOptions)
    $tr.find('div.game').remove()

    @$tableNode.append(tr[0])
    Twine.bind()

  gameAssigned: (game, slot) ->
    fieldId = $(slot).data('field-id')
    rowIdx = $(slot).parent().index()

    startTime = $(slot).parent().find('input').val()
    startTime = moment(startTime).format()

    $game = $(game)
    $game.attr('data-changed', true)
    $game.attr('data-row-idx', rowIdx)
    $game.attr('data-field-id', fieldId)
    $game.attr('data-start-time', startTime)

  gameUnassigned: (game) ->
    $game = $(game)
    $game.attr('data-changed', true)
    $game.attr('data-row-idx', -1)
    $game.attr('data-field-id', '')
    $game.attr('data-start-time', '')

  timeUpdated: (event) ->
    rowIdx = $(event.target).closest('tr').index()

    startTime = $(event.target).val()
    startTime = moment(startTime).format()

    games = $("[data-row-idx=#{rowIdx}]")
    games.attr('data-changed', true)
    games.attr('data-start-time', startTime)

  saveSchedule: (form) ->
    @_startLoading(form)
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
    @_clearGameErrors()

    $.ajax
      type: 'POST'
      url: form.action
      data: {games: games}
      error: (response) =>
        @_finishLoading(form)
        @_addGameErrors(response.responseJSON.game_id)
        Admin.Flash.error(response.responseJSON.error)
      success: (response) =>
        @_finishLoading(form)
        Admin.Flash.notice('Schedule saved')

  _addGameErrors: (game_id) ->
    $("[data-game-id=#{game_id}]").addClass('game-error')

  _clearGameErrors: ->
    $('.game').removeClass('game-error')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $(form).find(':submit').removeClass('is-loading')

  initDraggable: ->
    interact('.draggable').draggable({
      inertia: true,

      restrict:
        restriction: "parent",
        endOnly: true,
        elementRect: { top: 0, left: 0, bottom: 1, right: 1 }

      onmove: (event) =>
        @_moveElement(event.target, event.dx, event.dy)
    })

  _moveElement: (target, dx, dy) ->
    x = (parseFloat(target.getAttribute('data-x')) || 0) + dx
    y = (parseFloat(target.getAttribute('data-y')) || 0) + dy

    target.style.webkitTransform =
    target.style.transform =
      'translate(' + x + 'px, ' + y + 'px)'

    target.setAttribute('data-x', x)
    target.setAttribute('data-y', y)

  initDropzone: ->
    interact('.dropzone').dropzone({
    accept: '.game',
    overlap: 0.5,
    ondragenter: (event) ->
      th = getTableHeader($(event.target))
      th.addClass('drop-target')
      event.target.classList.add('drop-target')

    ondragleave: (event) =>
      th = getTableHeader($(event.target))
      th.removeClass('drop-target')
      event.target.classList.remove('drop-target')
      @gameUnassigned(event.relatedTarget)

    ondropdeactivate: (event) ->
      th = getTableHeader($(event.target))
      th.removeClass('drop-target')
      event.target.classList.remove('drop-target')

    ondrop: (event) =>
      @gameAssigned(event.relatedTarget, event.target)
  })

getTableHeader = ($td) ->
  $td.closest('table').find('th').eq($td.index())
