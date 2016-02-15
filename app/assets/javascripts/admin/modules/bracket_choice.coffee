class Admin.BracketChoice

  constructor: (node) ->
    @$numberInput = $(node).find('#division_num_teams')
    @$selectInput = $(node).find('#division_bracket_type')

    @$numberInput.on 'change', @numberChanged

  numberChanged: =>
    num = parseInt(@$numberInput.val())
    validBrackets = _.filter(Admin.BracketDb, (b) -> b.num_teams == num)

    @$selectInput.empty()

    if validBrackets.length == 0
      @$selectInput.attr('disabled', true)
    else
      @$selectInput.attr('disabled', false)

    @$selectInput.append validBrackets.map (b) =>
      $("<option>#{b.name}</option>")

    @$selectInput.change()
