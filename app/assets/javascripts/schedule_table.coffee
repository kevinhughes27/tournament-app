class TournamentApp.ScheduleTable

  constructor: (@$tableNode, @teams) ->
    @$fieldTables = @$tableNode.find('.editable-table')
    @$fieldTables.editableTableWidget()
    @newIdx = 1

    @$tableNode.contextmenu
      target: '#table-menu'
      before: @menuLoad
      onItem: @menuSelect

    @teamIdsToNames()

    @$tableNode.on 'change', (event) =>
      @currentCell = event.target
      switch @currentCell.getAttribute('id')
        when 'team' then @teamIdToName(@currentCell)
        when 'time' then @timeCellChanged()
        else null

  menuLoad: (e, context) =>
    @currentCell = e.target

  menuSelect: (context, e) =>
    switch $(e.target).data('action')
      when 'add' then @addRow()
      when 'delete' then @deleteRow()
      else nul

  addRow: (rowData = null) ->
    tr = @_newRow(rowData)
    for table in @$fieldTables
      $(table).append(tr.clone()[0])

  _newRow: (rowData) ->
    tr = @$fieldTables.find('tbody tr')[0]
    tr = $(tr).clone()
    tds = tr.find('td')
    tds.html("")

    if rowData
      $(td).html(rowData[idx]) for td, idx in tds.not('.hide')

    return tr

  deleteRow: ->
    rowIdx = @_currentRowIdx()
    for table in @$fieldTables
      row = $(table).find("tr:eq(#{rowIdx})")
      row.remove()

  timeCellChanged: ->
    newTime = @currentCell.innerHTML
    rowIdx = rowIdx = @_currentRowIdx()
    for table in @$fieldTables
      row = $(table).find("tr:eq(#{rowIdx})")
      td = $(row).find('td#time')
      td.html(newTime)

  _currentRowIdx: ->
    $(@currentCell).parent('tr').index() + 1 # off by one for dom ops

  teamIdsToNames: ->
    for table in @$fieldTables
      @teamIdToName(cell) for cell in $(table).find('td#team')

  teamIdToName: (cell) ->
    team = _.find(@teams, (team) -> "#{team.id}" == cell.innerHTML)
    cell.innerHTML = team.name if team

  teamNamesToIds: ->
    for table in @$fieldTables
      @teamNameToId(cell) for cell in $(table).find('td#team')

  teamNameToId: (cell) ->
    team = _.find(@teams, (team) -> team.name == cell.innerHTML)
    cell.innerHTML = team.id if team

  uploadCsv: (evt) ->
    if !@browserSupportFileUpload()
      alert('File upload not supported by this browser')
    else
      file = evt.target.files[0]
      reader = new FileReader()
      reader.readAsText(file)
      reader.onload = (event) =>
        csvData = event.target.result
        data = $.csv.toArrays(csvData)
        old_trs = @$tableNode.find('tbody > tr')
        @addRow(rowData) for rowData in data[1..-1] # skip header
        old_trs.remove()

  browserSupportFileUpload: ->
    window.File && window.FileReader && window.FileList && window.Blob

  save: (form) ->
    Turbolinks.ProgressBar.start()
    @teamNamesToIds()

    games = []
    for table in @$fieldTables
      $table = $(table)
      fieldId = $table.data('field-id')
      fieldGames = $table.tableToJSON()

      for game in fieldGames
        game.field_id = fieldId
        games.push game

    $.ajax
      type: 'POST'
      url: form.action
      data: {games: games}
      success: (response) ->
         Turbolinks.replace(response)
         Turbolinks.ProgressBar.done()
