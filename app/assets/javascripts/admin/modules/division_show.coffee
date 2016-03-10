class Admin.DivisionShow
  SELECT_BRACKET_NODE: '#division_bracket_type'

  constructor: ->
    Twine.afterBound =>
      bracketName = $(@SELECT_BRACKET_NODE).val()
      @bracket.render(bracketName)

    $(@SELECT_BRACKET_NODE).on 'change', (event) =>
      bracketName = $(event.target).val()
      @bracket.render(bracketName)
