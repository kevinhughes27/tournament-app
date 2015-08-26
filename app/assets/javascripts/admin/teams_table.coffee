class Admin.TeamsTable

  constructor: ->
    Twine.afterBound =>
      @_initTeamsList()
      @_initEditableTable()

  _initTeamsList: ->
    @teamsList = new List('teams', {
      valueNames: [
        'name',
        'division',
        'seed',
        'email',
        'sms',
        'twitter'
      ]
    })

  _initEditableTable: ->
    @$tableNode = $('.editable-table')
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

  addRow: (rowData = null)->
    tr = @$tableNode.find('tr')[1]
    tr = $(tr).clone()
    tds = tr.find('td')
    tds.html("")
    if rowData
      $(td).html(rowData[idx]) for td, idx in tds.not('.hide')

    @$tableNode.append(tr[0])

  deleteRow: ->
    row = $(@currentCell).parent('tr')
    row.remove()

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
        @addRow(rowData) for rowData in data[1..-1] # skip header

  browserSupportFileUpload: ->
    window.File && window.FileReader && window.FileList && window.Blob

  save: (form) ->
    Turbolinks.ProgressBar.start()
    data = {teams: @$tableNode.tableToJSON()}

    $.ajax
      type: 'POST'
      url: form.action
      data: data
      success: (response) ->
         Turbolinks.replace(response)
         Turbolinks.ProgressBar.done()
