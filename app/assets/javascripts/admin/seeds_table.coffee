class Admin.SeedsTable

  constructor: (@$tableNodes) ->
    @$tableNodes.editableTableWidget()

  save: (form) ->
    Turbolinks.ProgressBar.start()

    teams = []
    teams.push $(node).tableToJSON()... for node in @$tableNodes

    $.ajax
      type: 'PUT'
      url: form.action
      data: {teams: teams}
      success: (response) ->
         Turbolinks.replace(response)
         Turbolinks.ProgressBar.done()
