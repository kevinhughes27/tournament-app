class TournamentApp.EditableTable

  constructor: (@$tableNode) ->
    @$tableNode.editableTableWidget()

    @$tableNode.contextmenu
      target: '#table-menu'
      before: @menuLoad
      onItem: @menuSelect

  menuLoad: (e, context) =>
    @currentCell = e.target

  menuSelect: (context, e) =>
    switch $(e.target).data('action')
      when 'delete' then @_deleteRow()
      else null

  _deleteRow: ->
    row = $(@currentCell).parent('tr')
    row.remove()
