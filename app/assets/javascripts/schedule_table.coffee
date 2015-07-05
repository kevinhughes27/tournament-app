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

        old_trs = @$fieldTables.find('tbody > tr')
        chunkSize = $(old_trs[0]).find('td').not('hide').length - 1

        for fullRowData in data[1..-1] # skip header
          @addRow(chunk) for chunk in fullRowData.chunk(chunkSize)

        old_trs.remove()
        @teamIdsToNames()

  browserSupportFileUpload: ->
    window.File && window.FileReader && window.FileList && window.Blob

  exportCsv: ->
    trs = @$fieldTables.find('tbody > tr')
    colsPerFields = $(trs[0]).find('td').not('hide').length - 1

    header = ( "#{field.innerHTML}#{Array(colsPerFields).join(', ')}," for field in @$tableNode.find('th#field')).join('')

    headerRow = []
    for table in @$fieldTables
      row = $(table).find("tr:eq(0)")
      headerRow.push ( th.innerHTML for th in row.find('th').not('.hide'))...
    header2 = "#{headerRow}\n"

    body = ""
    numRows = $(@$fieldTables[0]).find('tbody > tr').length
    for rowIdx in [1..numRows] # skip header row
      bodyRow = []
      for table in @$fieldTables
        row = $(table).find("tr:eq(#{rowIdx})")
        bodyRow.push ( td.innerHTML for td in row.find('td').not('.hide'))...
      body += "#{bodyRow}\n"

    csv = "data:text/csv;charset=utf-8,#{header}\n#{header2}#{body}"
    encodedUri = encodeURI(csv)
    link = document.createElement("a")
    link.setAttribute("href", encodedUri)
    link.setAttribute("download", "schedule.csv")
    link.click()

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

Array::chunk = (chunkSize) ->
  array = this
  [].concat.apply [], array.map((elem, i) ->
    (if i % chunkSize then [] else [array.slice(i, i + chunkSize)])
  )
