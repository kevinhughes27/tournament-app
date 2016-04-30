class Admin.ScheduleDnD

  constructor: ->
    @rd = REDIPS.drag
    @rd.init()
    @rd.dropMode = 'single'
    @rd.hover = {}

    @rd.event.clicked = (dropCell) ->
      gameNode = dropCell.children[0]
      gameNode.classList.remove('game-error')

    @rd.event.deleted = (__, gameNode) =>
      @_unhighlight()
      @_gameUnassigned(gameNode)

      divisionId = $(gameNode).attr('data-division-id')
      # consciously appending a simple row on purpose
      # this table actually has 2 rows but its edge casey
      # enough to not need to insert at maximum space efficiency
      $("table#division-#{divisionId} tbody").append(
        "<tr>
          <td class='redips-mark'>
            #{gameNode.outerHTML}
          </td>
        </tr>"
      )

      @rd.init()

    @rd.event.dropped = (dropCell) =>
      # game was dropped and returned to original unscheduled position
      return if 'redips-mark' in dropCell.classList

      @_hideBanner()
      @_unhighlight()
      gameNode = dropCell.children
      @_gameAssigned(gameNode, dropCell)

    @rd.event.changed = (dropCell) =>
      @_unhighlight()

      if 'redips-trash' in dropCell.classList
        @_highlightTrash()
      else
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

  _gameUnassigned: (game) ->
    $game = $(game)
    $game.attr('data-changed', true)
    $game.removeAttr('data-row-idx')
    $game.removeAttr('data-field-id')
    $game.removeAttr('data-start-time')

  _hideBanner: ->
    $banner = $('.alert-dismissable')
    $banner.fadeOut(400)

  _highlightTrash: ->
    $('#games-card').find('.box-body').addClass('drop-hover')

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

  _unhighlight: ->
    $('.drop-hover').removeClass('drop-hover')
    @_unhighlightCells()

  _unhighlightCells: ->
    $('.drop-target').removeClass('drop-target')
    $('.dropzone-label').removeClass('dropzone-label')
    @_drop.destroy() if @_drop && this._drop.drop
