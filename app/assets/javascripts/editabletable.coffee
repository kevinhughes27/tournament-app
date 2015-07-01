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

  addRow: (row = null)->
    tr = @$tableNode.find('tr')[1]
    tr = $(tr).clone()
    tds = tr.find('td')
    tds.html("")

    if row
      $(td).html(row[idx]) for td, idx in tds.not('.hide')

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
        old_trs = @$tableNode.find('tbody > tr')
        @addRow(row) for row in data[1..-1]
        old_trs.remove()

  browserSupportFileUpload: ->
    window.File && window.FileReader && window.FileList && window.Blob

  save: (form) ->
    Turbolinks.ProgressBar.start()
    $.ajax
      type: 'POST'
      url: form.action
      data: {teams: @$tableNode.tableToJSON()}
      success: (response) ->
         Turbolinks.replace(response)
         Turbolinks.ProgressBar.done()
