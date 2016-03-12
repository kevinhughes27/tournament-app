class Admin.DivisionShow
  BRACKET_TYPE_SELECTOR: '#division_bracket_type'
  SEEDS_SELECTOR: "[name='seeds[]']"

  constructor: ->
    @canSeed = true
    @bracketName = $(@BRACKET_TYPE_SELECTOR).val()
    @seeds = @_seeds()

    Twine.afterBound =>
      bracketName = $(@BRACKET_TYPE_SELECTOR).val()
      @bracket.render(bracketName)

    $(@BRACKET_TYPE_SELECTOR).on 'change', (event) =>
      bracketName = $(event.target).val()
      @bracket.render(bracketName)
      @canSeed = @_canSeed()
      Twine.refreshImmediately()

    $(@SEEDS_SELECTOR).on 'change', (event) =>
      @canSeed = @_canSeed()
      Twine.refreshImmediately()

  _canSeed: ->
    @bracketName == $(@BRACKET_TYPE_SELECTOR).val() &&
    _.isEqual(@seeds, @_seeds())

  _seeds: ->
    (node.value for node in $(@SEEDS_SELECTOR))
