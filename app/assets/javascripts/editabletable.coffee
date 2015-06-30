class TournamentApp.EditableTable

  constructor: (@$tableNode) ->
    @$tableNode.editableTableWidget()
    @newIdx = 1

    @$tableNode.contextmenu
      target: '#table-menu'
      before: @menuLoad
      onItem: @menuSelect

  menuLoad: (e, context) =>
    @currentCell = e.target

  menuSelect: (context, e) =>
    switch $(e.target).data('action')
      when 'add' then @addRow()
      when 'delete' then @deleteRow()
      else null

  addRow: ->
    row = @$tableNode.find('tr')[1]
    row = $(row).clone()
    row.find('td.hide').html(" ")
    #row.find('td').html(" ") # why does this make the table row short?
    @$tableNode.append(row[0])


  deleteRow: ->
    row = $(@currentCell).parent('tr')
    row.remove()

  save: (form) ->
    Turbolinks.ProgressBar.start()
    $.ajax
      type: 'POST'
      url: form.action
      data: {teams: @$tableNode.tableToJSON()}
      success: (response) ->
         Turbolinks.replace(response)
         Turbolinks.ProgressBar.done()
