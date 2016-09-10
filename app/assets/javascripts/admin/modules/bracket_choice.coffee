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

    validBrackets = BracketDb.BRACKETS.filter((b) ->
      b.num_teams == numTeams && b.days == numDays
    )
    @$selectInput.empty()

    if validBrackets.length == 0
      @$selectInput.attr('disabled', true)
    else
      @$selectInput.attr('disabled', false)

    @$selectInput.append validBrackets.map (b) =>
      $("<option value='#{b.handle}'>#{b.name}</option>")

    @$selectInput.change()
