class TournamentApp.App

  constructor: (@tournmanentLocation, @zoom, @fields, @teams, @games) ->
    @drawerOpen = false
    @modalOpen = false
    @searchOpen = false
    @scheduleScreen = false
    @submitScoreScreenA = false
    @submitScoreScreenB = false

    window.initializeMap = @initializeMap
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=drawing&callback=initializeMap'
    document.body.appendChild(script)

  initializeMap: =>
    @map = new google.maps.Map(document.getElementById('map-canvas'), {
      zoom: @zoom,
      center: new google.maps.LatLng(@tournmanentLocation...),
      mapTypeId: google.maps.MapTypeId.SATELLITE
      disableDefaultUI: true
    })

    @drawFields()
    @markers = []
    @initApp()

  drawFields: ->
    for field in @fields
      @_initField(field)
      @_drawField(field)

  _initField: (field) ->
    field.center = new google.maps.LatLng(field.lat, field.long)

    field.points = []
    for pt in JSON.parse(field.polygon)
      field.points.push new google.maps.LatLng(pt.A, pt.F)


  _drawField: (field) ->
    polygon = new google.maps.Polygon(
      paths: field.points,
      strokeColor: '#29617D'
      strokeWeight: 5
      fillOpacity: 0
    )

    field.shape = polygon
    polygon.setMap(@map)

  _addMarker: (lat, lng, title) ->
    latLng = new google.maps.LatLng(lat, lng)

    @markers.push new google.maps.Marker(
      position: latLng,
      map: @map
      title: title
    )

  _clearMarkers: ->
    marker.setMap(null) for marker in @markers
    @markers = []

  initApp: ->
    $node = $('#field-search > select')
    $node.selectize(valueField: 'name', labelField: 'name', searchField: 'name')
    @fieldSelectize = $node[0].selectize
    @fieldSelectize.on 'blur', (event) =>
      @fieldSearchOpen = false
      Twine.refresh()

    $node = $('#team-search > select')
    $node.selectize(valueField: 'name', labelField: 'name', searchField: 'name')
    @teamSelectize = $node[0].selectize
    @teamSelectize.on 'blur', (event) =>
      @teamSearchOpen = false
      Twine.refresh()

    @pointMeThere = new TournamentApp.PointMeThere()

    @fingerprint = new Fingerprint2()
    @fingerprint.get (result) ->
      $('input#submitter_fingerprint').val(result)

  showFieldSelect: =>
    @fieldSearchOpen = true
    @drawerOpen = false
    Twine.refresh()
    @fieldSelectize.focus()

  fieldSelected: (event) ->
    @fieldSearchOpen = false
    selected = $(event.target).val()
    field = _.find(@fields, (field) -> field.name is selected)
    @pointToField(field) if field
    Twine.refresh()

  findField: (fieldName) ->
    @scheduleScreen = false
    field = _.find(@fields, (field) -> field.name is fieldName)
    @pointToField(field) if field
    Twine.refresh()

  showTeamSelect: =>
    @teamSearchOpen = true
    @drawerOpen = false
    Twine.refresh()
    @teamSelectize.focus()

  teamSelected: (event) =>
    @teamSearchOpen = false
    selected = $(event.target).val()
    team = _.find(@teams, (team) -> team.name is selected)
    games = _.filter(@games, (game) -> game.away_id == team.id || game.home_id == team.id)
    games = _.sortBy(games, (game) -> game.start_time)

    cutOffIdx = _.findIndex(games, (game) -> Date.parse(game.start_time) > Date.now())
    # cut off is all games with start time ahead of time now.
    # I could rewind this by one which is *likey* the current game.
    # Games should have a duration (tournaments have hard cap so why not give them that?)
    currentGame = games[cutOffIdx - 1]

    if currentGame
      field = _.find(@fields, (field) -> field.id == currentGame.field_id)

    @pointToField(field) if field
    Twine.refresh()

  pointToField: (field) ->
    @pointMeThere.setDestination(field.lat, field.long, field.name)
    @pointMeThere.start (event) =>
      @_clearMarkers()
      bounds = new google.maps.LatLngBounds()

      if event.lat && event.long
        @_addMarker(event.lat, event.long, 'Location')
        location = new google.maps.LatLng(event.lat, event.long)
        bounds.extend(location)

      @_addMarker(event.dstLat, event.dstLng, 'Destination')
      destination = new google.maps.LatLng(event.dstLat, event.dstLng)
      bounds.extend(destination)

      @map.fitBounds(bounds)
      @map.setZoom(@zoom)

  # Schedule view
  scheduleSearchChange: (event)->
    @lastScheduleSearch = $(event.target).val()
    Twine.refresh()

  scheduleFilter: (teamNames) ->
    if @lastScheduleSearch
      teamNames.join(',').match("#{@lastScheduleSearch}")
    else
      true


  # Submit score A view
  submitSearchChange: (event) ->
    @lastSubmitSearch = $(event.target).val()
    Twine.refresh()

  submitFilter: (teamNames) ->
    if @lastSubmitSearch
      teamNames.join(',').match("#{@lastSubmitSearch}")

  vsTeam: (home, away) ->
    return unless @lastSubmitSearch == home ||
                  @lastSubmitSearch == away

    "#{home}#{away}".replace @lastSubmitSearch, ""

  submitScoreForm: (gameId, home, away) ->
    team = _.find(@teams, (team) => team.name is @lastSubmitSearch)
    vsTeam = @vsTeam(home, away)

    $('.score-label')[0].innerHTML = team.name
    $('.score-label')[1].innerHTML = vsTeam
    $('input#game_id').val(gameId)
    $('input#team_id').val(team.id)

    @submitScoreScreenB = true
    Twine.refresh()

  submitScore: (form) ->
    $.ajax
      url: form.action
      type: 'POST'
      data: $(form).serialize()
      complete: =>
        @submitScoreScreenA = false
        @submitScoreScreenB = false
        Twine.refresh()
