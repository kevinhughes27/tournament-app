class Admin.ScheduleDnD

  constructor: ->
    @rd = REDIPS.drag
    @rd.init()
    @rd.dropMode = 'single'
    @rd.hover = {}

    @rd.event.clicked = (dropCell) ->
      gameNode = dropCell.children[0]
      gameNode.classList.remove('game-error')

    @rd.event.dropped = (dropCell) =>
      # game was dropped and returned to original position
      return if 'redips-mark' in dropCell.classList

      @_hideBanner()
      @_unhighlightCells()
      gameNode = dropCell.children
      @_gameAssigned(gameNode, dropCell)

    @rd.event.changed = (dropCell) =>
      @_unhighlightCells()
      @_highlightCells(dropCell)

  _gameAssigned: (game, slot) ->
    fieldId = $(slot).data('field-id')
    rowIdx = $(slot).parent().index()

    startTime = $(slot).parent().find('input').val()
    startTime = moment(startTime).format()

    $game = $(game)
    $game.attr('data-changed', true)
    $game.attr('data-row-idx', rowIdx)
    $game.attr('data-field-id', fieldId)
    $game.attr('data-start-time', startTime)

  _hideBanner: ->
    $banner = $('.alert-dismissable')
    $banner.fadeOut(400)

  _highlightCells: (td) ->
    $td = $(td)
    $td.addClass('drop-target')
    fieldName = $td.data('field-name')

    @_drop = new Drop
      target: document.querySelector('.drop-target')
      content: fieldName
      classes: 'dropzone-label'
      position: 'top center'
    @_drop.open()

  _unhighlightCells: ->
    $('.drop-target').removeClass('drop-target')
    $('.dropzone-label').removeClass('dropzone-label')
    @_drop.destroy() if @_drop && this._drop.drop
