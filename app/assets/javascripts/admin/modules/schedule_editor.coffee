class Admin.ScheduleEditor

  constructor: (@$tableNode, @timeCap) ->
    @rd = REDIPS.drag
    @rd.init()
    @rd.dropMode = 'single'
    @rd.hover = {}

    @rd.event.clicked = (dropCell) ->
      gameNode = dropCell.children[0]
      gameNode.classList.remove('game-error')

    @rd.event.dropped = (dropCell) =>
      unhighlightCells()
      gameNode = dropCell.children
      @gameAssigned(gameNode, dropCell)

    @rd.event.changed = (dropCell) ->
      highlightHeaderCell(dropCell)

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
    $tr.find('.occupied').removeClass('occupied')

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

  timeUpdated: (event) ->
    rowIdx = $(event.target).closest('tr').index()

    startTime = $(event.target).val()
    startTime = moment(startTime).format()

    games = $("[data-row-idx=#{rowIdx}]")
    games.attr('data-changed', true)
    games.attr('data-start-time', startTime)

  saveSchedule: (form) ->
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
          Admin.Flash.error(response.responseJSON.error)
        else
          Admin.Flash.error('Sorry, something went wrong.')
      success: (response) =>
        @_finishLoading(form)
        @_keepScroll( -> Turbolinks.replace(response))
        Admin.Flash.notice('Schedule saved')

  _keepScroll: (func) ->
    node = $('#games-card')[0]
    scrollLeft1 = node.scrollLeft
    scrollTop1 = node.scrollTop
    node = $('#fields-card')[0]
    scrollLeft2 = node.scrollLeft
    scrollTop2 = node.scrollTop

    func.call()

    node = $('#games-card')[0]
    node.scrollLeft = scrollLeft1
    node.scrollTop = scrollTop1
    node = $('#fields-card')[0]
    node.scrollLeft = scrollLeft2
    node.scrollTop = scrollTop2

  _addGameErrors: (game_id) ->
    $("[data-game-id=#{game_id}]").addClass('game-error')

  _clearGameErrors: ->
    $('.game').removeClass('game-error')

  _finishLoading: (form) ->
    Turbolinks.ProgressBar.done()
    $(form).find(':submit').removeClass('is-loading')

highlightHeaderCell = (td) ->
  unhighlightCells()
  $td = $(td)
  getTableHeader($td).addClass('drop-target')
  $td.addClass('drop-target')

unhighlightCells = ->
  $('.drop-target').removeClass('drop-target')

getTableHeader = ($td) ->
  $td.closest('table').find('th').eq($td.index())
