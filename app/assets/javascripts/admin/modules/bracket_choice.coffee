class Admin.BracketChoice

  constructor: (node, @brackets) ->
    @$numberInput = $(node).find('#division_num_teams')
    @$selectInput = $(node).find('#division_bracket_type')

    @$numberInput.on 'change', @numberChanged

  numberChanged: =>
    num = parseInt(@$numberInput.val())
    validBrackets = _.filter(@brackets, (b) -> b[0] == num)

    @$selectInput.empty()

    if validBrackets.length == 0
      @$selectInput.attr('disabled', true)
    else
      @$selectInput.attr('disabled', false)

    @$selectInput.append validBrackets.map (b) =>
      $("<option>#{b[1]}</option>")

    @$selectInput.change()
