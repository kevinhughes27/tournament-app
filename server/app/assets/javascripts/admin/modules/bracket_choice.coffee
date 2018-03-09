class Admin.BracketChoice
  constructor: (node) ->
    @$numberInput = $(node).find('#division_num_teams')
    @$daysInput = $(node).find('#division_num_days')
    @$selectInput = $(node).find('#division_bracket_type')

    @$numberInput.on 'change', @updateChoices
    @$daysInput.on 'change', @updateChoices

  updateChoices: =>
    numDays = parseInt(@$daysInput.val())
    numTeams = parseInt(@$numberInput.val())

    $.get({
      url: '/admin/brackets',
      data: {num_teams: numTeams, num_days: numDays},
      success: @_updateDropdown
    })

  _updateDropdown: (brackets) =>
    @$selectInput.empty()

    if brackets.length == 0
      @$selectInput.attr('disabled', true)
    else
      @$selectInput.attr('disabled', false)

    @$selectInput.append brackets.map (b) =>
      $("<option value='#{b.handle}'>#{b.name}</option>")

    @$selectInput.change()
