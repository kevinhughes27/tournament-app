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

      hideBanner()
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

hideBanner = ->
  $banner = $('.alert-dismissable')
  $banner.fadeOut(400, -> $('.schedule-table > table').floatThead('reflow'))

highlightHeaderCell = (td) ->
  unhighlightCells()
  $td = $(td)
  $th = getTableHeader($td)
  $th.addClass('drop-target')
  $td.addClass('drop-target')

unhighlightCells = ->
  $('.drop-target').removeClass('drop-target')

getTableHeader = ($td) ->
  $table = $('.floatThead-container')
  $table.find('th').eq($td.index())
