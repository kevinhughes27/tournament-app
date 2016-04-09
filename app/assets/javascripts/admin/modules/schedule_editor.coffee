class Admin.ScheduleEditor

  constructor: ->
    @rd = REDIPS.drag
    @rd.init()
    @rd.dropMode = 'single'
    @rd.hover = {}

    @rd.event.clicked = (dropCell) ->
      gameNode = dropCell.children[0]
      gameNode.classList.remove('game-error')

    @rd.event.dropped = (dropCell) =>
      # game was dropped and returned to list
      return if dropCell.classList[0] == 'redips-mark'

      unhighlightCells()
      gameNode = dropCell.children
      @gameAssigned(gameNode, dropCell)

    @rd.event.changed = (dropCell) ->
      highlightHeaderCell(dropCell)

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

highlightHeaderCell = (td) ->
  unhighlightCells()
  $td = $(td)
  getTableHeader($td).addClass('drop-target')
  $td.addClass('drop-target')

unhighlightCells = ->
  $('.drop-target').removeClass('drop-target')

getTableHeader = ($td) ->
  $td.closest('table').find('th').eq($td.index())
