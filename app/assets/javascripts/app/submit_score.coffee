class TournamentApp.SubmitScoreScreen

  constructor: (@app) ->
    @active = false
    @formActive = false

  show: ->
    @active = true
    location.hash = "submit-score"
    Twine.refresh()

  close: ->
    @active = false
    location.hash = ""
    Twine.refresh()

  closeForm: ->
    @formActive = false
    Twine.refresh()

  searchChange: (event) ->
    @lastSearch = $.trim( $(event.target).val() )
    Twine.refresh()

  filter: (teamNames) ->
    if @lastSearch
      # prevent accidently matching a substring
      teamNames.join(',').match("#{@lastSearch} vs") || teamNames.join(',').endsWith("vs #{@lastSearch}")

  vsTeam: (home, away) ->
    return unless @lastSearch == home ||
                  @lastSearch == away

    "#{home}#{away}".replace @lastSearch, ""

  showForm: (gameId, home, away) ->
    team = _.find(@app.teams, (team) => team.name is @lastSearch)
    vsTeam = @vsTeam(home, away)

    $('.score-label')[0].innerHTML = team.name
    $('.score-label')[1].innerHTML = vsTeam
    $('input#game_id').val(gameId)
    $('input#team_id').val(team.id)

    @formActive = true
    Twine.refresh()

  submitScore: (form) ->
    $.ajax
      url: form.action
      type: 'POST'
      data: $(form).serialize()
      complete: =>
        @active = false
        @formActive = false
        $(form)[0].reset();
        $('div#score-form').scrollTo(0)
        Twine.refresh()
