class Admin.DivisionShow
  BRACKET_TYPE_SELECTOR: '#division_bracket_type'
  SEEDS_SELECTOR: "[name='seeds[]']"

  constructor: ->
    @canSeed = true
    @bracketHandle = $(@BRACKET_TYPE_SELECTOR).val()
    @seeds = @_seeds()

    Twine.afterBound =>
      bracketHandle = $(@BRACKET_TYPE_SELECTOR).val()
      @bracket.render(bracketHandle)

    $(@BRACKET_TYPE_SELECTOR).on 'change', (event) =>
      bracketHandle = $(event.target).val()
      @bracket.render(bracketHandle)
      @canSeed = @_canSeed()
      Twine.refreshImmediately()

    $(@SEEDS_SELECTOR).on 'change', (event) =>
      @canSeed = @_canSeed()
      Twine.refreshImmediately()

  _canSeed: ->
    @bracketHandle == $(@BRACKET_TYPE_SELECTOR).val() &&
    _.isEqual(@seeds, @_seeds())

  _seeds: ->
    (node.value for node in $(@SEEDS_SELECTOR))
