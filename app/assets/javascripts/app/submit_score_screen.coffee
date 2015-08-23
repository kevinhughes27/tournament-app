class App.SubmitScoreScreen

  constructor: (@app) ->
    @active = false
    @formActive = false
    @successActive = false

  show: ->
    @active = true
    location.hash = "submit-score"
    Twine.refresh()

  close: ->
    @active = false
    location.hash = ""
    Twine.refresh()

  searchChange: (event) ->
    @lastSearch = $.trim( $(event.target).val() )
    Twine.refresh()

  filter: (teamNames) ->
    if @lastSearch
      teamNames.match("#{@lastSearch} vs") || teamNames.endsWith("vs #{@lastSearch}")

  vsTeam: (home, away) ->
    return unless @lastSearch == home || @lastSearch == away
    "#{home}#{away}".replace @lastSearch, ""

  showForm: (gameId, home, away) ->
    team = _.find(@app.teams, (team) => team.name is @lastSearch)
    vsTeam = @vsTeam(home, away)
    @_prepareForm(team.name, vsTeam, gameId, team.id)
    @formActive = true
    Twine.refresh()

  _prepareForm: (teamName, vsTeam, gameId, teamId) ->
    $('.score-label')[0].innerHTML = teamName
    $('.score-label')[1].innerHTML = vsTeam
    $('input#game_id').val(gameId)
    $('input#team_id').val(teamId)

  closeForm: ->
    @formActive = false
    Twine.refresh()

  submitScore: (form) ->
    $.ajax
      url: form.action
      type: 'POST'
      data: $(form).serialize()
      complete: =>
        @showSuccess()
        @active = false
        @formActive = false
        @_resetForm(form)
        Twine.refresh()

  _resetForm: (form) ->
    $(form)[0].reset();
    $('div#score-form').scrollTo(0)

  showSuccess: ->
    @successActive = true
    Twine.refresh()
    $('.success-icon').addClass('bounceIn')

  closeSuccess: ->
    @successActive = false
    Twine.refresh()
    $('.success-icon').removeClass('bounceIn')
