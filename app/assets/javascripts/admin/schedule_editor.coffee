class Admin.ScheduleEditor

  constructor: (@$tableNode) ->
    @initDraggable()
    @initDropzone()

  addRow: ->
    tr = @$tableNode.find('tr')[1]
    tr = $(tr).clone()
    $(tr).find('input').val('')
    @$tableNode.append(tr[0])
    Twine.bind()

  gameDropped: (game, slot) ->
    fieldId = $(slot).data('field-id')
    rowIdx = $(slot).parent().index()
    time = $(slot).parent().find('input').val()

    $(game).attr('data-field-id', fieldId)
    $(game).attr('data-row-idx', rowIdx)
    $(game).attr('data-started-at', time)

  timeUpdated: (event) ->
    time = $(event.target).val()
    rowIdx = $(event.target).parent().index()
    games = $("[data-row-idx=#{rowIdx}]")
    games.attr('data-started-at', time)

  saveSchedule: ->
    # disable if times blank
    #debugger

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
    accept: '#game',
    overlap: 0.5,

    ondropactivate: (event) ->
      event.target.classList.add('drop-active')

    ondragenter: (event) ->
      draggableElement = event.relatedTarget
      dropzoneElement = event.target

      dropzoneElement.classList.add('drop-target')
      draggableElement.classList.add('can-drop')

    ondragleave: (event) ->
      event.target.classList.remove('drop-target')
      event.relatedTarget.classList.remove('can-drop')

    ondrop: (event) =>
      @gameDropped(event.relatedTarget, event.target)

    ondropdeactivate: (event) ->
      event.target.classList.remove('drop-active')
      event.target.classList.remove('drop-target')
  })
