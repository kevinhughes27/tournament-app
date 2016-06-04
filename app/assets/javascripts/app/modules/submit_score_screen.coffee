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
    $('#vs-team').text(vsTeam)

  closeForm: ->
    @formActive = false
    Twine.refresh()

  submitScore: (form) ->
    $.ajax
      url: form.action
      type: 'POST'
      data: $(form).serialize()
      success: =>
        @showSuccess()
        @_submitComplete(form)
      error: (response) =>
        $('div#score-form').scrollTo(0)
        errorMessage = response.responseJSON.join('\n')
        alert(errorMessage)


  showSuccess: ->
    @successActive = true
    Twine.refreshImmediately()
    $('.success-icon').addClass('bounceIn')

  _submitComplete: (form) ->
    delay 1000, =>
      @active = false
      @formActive = false
      $(form)[0].reset();
      $(form).find('#submit-score').prop('disabled', false)
      $('div#score-form').scrollTo(0)
      Twine.refresh()

  closeSuccess: ->
    @successActive = false
    Twine.refresh()
    $('.success-icon').removeClass('bounceIn')
