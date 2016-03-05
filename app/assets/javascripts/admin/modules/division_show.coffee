class Admin.DivisionShow
  SELECT_BRACKET_NODE: '#division_bracket_type'

  constructor: ->
    $(@SELECT_BRACKET_NODE).on 'change', (event) =>
      bracketName = $(event.target).val()
      @bracketVis.draw(bracketName)
