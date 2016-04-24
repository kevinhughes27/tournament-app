class App.MainScreen

  constructor: (@lat, @long, @zoom, @fields, @teams, @games, @timeCap) ->
    location.hash = ""
    @drawerOpen = false
    @findingField = false
    @findText = ''
    @fieldSearchOpen = false
    @teamSearchOpen = false
    @initApp()

  initializeMap: ->
    @appMap = new App.Map(@, @lat, @long, @zoom)

  initApp: ->
    @scheduleScreen = new App.ScheduleScreen(@)
    @submitScoreScreen = new App.SubmitScoreScreen(@)
    @pointMeThere = new App.PointMeThere()

    window.addEventListener "hashchange", (event) =>
      # back button pretty much just resets to main
      if location.hash == ""
        @scheduleScreen.active = false
        @submitScoreScreen.active = false
        @submitScoreScreen.formActive = false
        Twine.refresh()

  showFieldSelect: =>
    return alert("There are no fields!") if _.isEmpty(@fields)

    @fieldSearchOpen = true
    @teamSearchOpen = false
    @drawerOpen = false
    @finishPointToField()
    Twine.refresh()
    _.defer -> $('#main-field-search').focus()

  showTeamSelect: =>
    return alert("There are no teams!") if _.isEmpty(@teams)

    @teamSearchOpen = true
    @fieldSearchOpen = false
    @drawerOpen = false
    @finishPointToField()
    Twine.refresh()
    _.defer -> $('#main-team-search').focus()

  searchBlur: ->
    @fieldSearchOpen = false
    @teamSearchOpen = false
    Twine.refresh()

  fieldSelected: (event) ->
    return if event.type == 'keyup' && event.keyCode != 13
    return if event.type == 'change' && $(event.target).val() == ''

    @fieldSearchOpen = false
    selected = $.trim( $(event.target).val() )
    field = _.find(@fields, (field) -> field.name is selected)

    if field
      @findText = "#{field.name}"
      @pointToField(field)

    Twine.refresh()

  teamSelected: (event) =>
    return if event.type == 'keyup' && event.keyCode != 13
    return if event.type == 'change' && $(event.target).val() == ''

    @teamSearchOpen = false
    selected = $.trim( $(event.target).val() )
    team = _.find(@teams, (team) -> team.name is selected)

    # filter games where the team isn't playing
    games = _.filter(@games, (game) -> game.away_id == team.id || game.home_id == team.id)

    # filter games that aren't over
    games = _.filter(games, (game) => @_currentTime() < moment.utc(game.start_time).add(@timeCap, 'minutes'))
    games = _.sortBy(games, (game) -> game.start_time)

    nextOrCurrentGame = games[0]

    if nextOrCurrentGame
      field = _.find(@fields, (field) -> field.id == nextOrCurrentGame.field_id)
      gameTime = moment.utc(nextOrCurrentGame.start_time).format('h:mm')
      @findText = "#{team.name} @ #{gameTime}"
      @pointToField(field) if field
    else
      alert("No Upcoming games for #{selected}")

    Twine.refresh()

  _currentTime: ->
    moment.utc()

  pointToField: (field) ->
    @appMap.clearMarkers()

    unless field.lat && field.long
      return alert("Field has no location!")

    @findingField = true
    @tooFarAlert = false

    @appMap.addMarker(field.lat, field.long)

    @pointMeThere.setDestination(field.lat, field.long, field.name)
    @pointMeThere.start (event) => _.throttle(@_pointToFieldCallback(event), 500)

  _pointToFieldCallback: (event) ->
    if event.distance > 1000
      alert("You're too far away!") unless @tooFarAlert
      @tooFarAlert = true
    else if event.lat && event.long
      @appMap.drawPointer(event.lat, event.long, event.heading)

  finishPointToField: ->
    @findingField = false
    @appMap.clearMarkers()
    @appMap.clearPointer()
    @appMap.centerMap()
    Twine.refresh()
