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
    $tr.find('.datetimepicker').datetimepicker()
    $tr.find('div.game').remove()

    @$tableNode.append(tr[0])
    Twine.bind()

  gameDropped: (game, slot) ->
    fieldId = $(slot).data('field-id')
    rowIdx = $(slot).parent().index()

    startTime = $(slot).parent().find('input').val()
    startTime = moment(startTime).format()

    $(game).attr('data-changed', true)
    $(game).attr('data-row-idx', rowIdx)
    $(game).attr('data-field-id', fieldId)
    $(game).attr('data-start-time', startTime)

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
        id: $(g).data('game-id')
        field_id: $(g).data('field-id')
        start_time: $(g).data('start-time')
      }
    games

  _save: (form, games) ->
    $.ajax
      type: 'POST'
      url: form.action
      data: {games: games}
      error: (response) =>
        @_finishLoading(form)
        Admin.Flash.error('error')
      success: (response) =>
        @_finishLoading(form)
        Admin.Flash.notice('Schedule saved')

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
    ondragenter: (event) -> event.target.classList.add('drop-target')
    ondragleave: (event) -> event.target.classList.remove('drop-target')
    ondropdeactivate: (event) -> event.target.classList.remove('drop-target')
    ondrop: (event) =>
      @gameDropped(event.relatedTarget, event.target)
  })
