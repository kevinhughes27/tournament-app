class TournamentApp.App

  constructor: (@tournmanentLocation, @zoom, @fields, @teams, @games, @timeCap) ->
    @drawerOpen = false
    @findingField = false
    @findText = ''
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

  centerMap: ->
    @map.setCenter(new google.maps.LatLng(@tournmanentLocation...))
    @map.setZoom(@zoom)

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
      title: title,
      position: latLng,
      map: @map,
      icon: {
        path: "M27.648 -41.399q0 -3.816 -2.7 -6.516t-6.516 -2.7 -6.516 2.7 -2.7 6.516 2.7 6.516 6.516 2.7 6.516 -2.7 2.7 -6.516zm9.216 0q0 3.924 -1.188 6.444l-13.104 27.864q-0.576 1.188 -1.71 1.872t-2.43 0.684 -2.43 -0.684 -1.674 -1.872l-13.14 -27.864q-1.188 -2.52 -1.188 -6.444 0 -7.632 5.4 -13.032t13.032 -5.4 13.032 5.4 5.4 13.032z",
        strokeColor: "#FFFFFF",
        strokeWeight: 3,
        scale: 0.5
      }
    )

  _addPointer: (lat, lng, rotation, title) ->
    latLng = new google.maps.LatLng(lat, lng)

    @markers.push new google.maps.Marker(
      title: title
      position: latLng,
      map: @map,
      icon: {
        path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
        strokeColor: "#FFFFFF",
        scale: 3
        rotation: rotation,
      },
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
    @findText = "Showing field #{field.name}"
    @pointToField(field) if field
    Twine.refresh()

  findField: (fieldName, home, away) ->
    @scheduleScreen = false
    field = _.find(@fields, (field) -> field.name is fieldName)
    @findText = "Showing field for #{home} vs #{away}"
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

    # filter games where the team isn't playing
    games = _.filter(@games, (game) -> game.away_id == team.id || game.home_id == team.id)

    # filter games that aren't over
    games = _.filter(games, (game) => moment() < moment(game.start_time).add(@timeCap, 'minutes'))
    games = _.sortBy(games, (game) -> game.start_time)

    nextOrCurrentGame = games[0]

    if nextOrCurrentGame
      field = _.find(@fields, (field) -> field.id == nextOrCurrentGame.field_id)
      gameTime = moment(nextOrCurrentGame.start_time).format('h:mm')
      @findText = "Showing field for team #{team.name} @ #{gameTime}"
      @pointToField(field) if field

    Twine.refresh()


  pointToField: (field) ->
    @findingField = true

    @pointMeThere.setDestination(field.lat, field.long, field.name)
    @pointMeThere.start (event) =>
      @_clearMarkers()
      bounds = new google.maps.LatLngBounds()

      if event.lat && event.long
        @_addPointer(event.lat, event.long, event.heading, 'Location')
        location = new google.maps.LatLng(event.lat, event.long)
        bounds.extend(location)

      @_addMarker(event.dstLat, event.dstLng, 'Destination')
      destination = new google.maps.LatLng(event.dstLat, event.dstLng)
      bounds.extend(destination)

      @map.fitBounds(bounds)

      if event.distance < 1000
        @map.setZoom(@zoom)

  getFindText: ->
    @findText

  finishPointToField: ->
    @findingField = false
    @_clearMarkers()
    @centerMap()
    Twine.refresh()

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
