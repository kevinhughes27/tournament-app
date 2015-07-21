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
        url: "/assets/fa-map-marker.svg",
        strokeColor: "#FFFFFF",
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
    @pointMeThere = new TournamentApp.PointMeThere()
    @fingerprint = new Fingerprint2()
    @fingerprint.get (result) ->
      $('input#submitter_fingerprint').val(result)

  showFieldSelect: =>
    @fieldSearchOpen = true
    @teamSearchOpen = false
    @drawerOpen = false
    Twine.refresh()
    _.defer -> $('#main-field-search').focus()

  fieldSelected: (event) ->
    @fieldSearchOpen = false
    selected = $(event.target).val()
    field = _.find(@fields, (field) -> field.name is selected)
    @findText = "#{field.name}"
    @pointToField(field) if field
    Twine.refresh()

  findField: (fieldName, home, away) ->
    @scheduleScreen = false
    field = _.find(@fields, (field) -> field.name is fieldName)
    @findText = "#{home} vs #{away}"
    @pointToField(field) if field
    Twine.refresh()

  showTeamSelect: =>
    @teamSearchOpen = true
    @fieldSearchOpen = false
    @drawerOpen = false
    Twine.refresh()
    _.defer -> $('#main-team-search').focus()

  teamSelected: (event) =>
    @teamSearchOpen = false
    selected = $(event.target).val()
    team = _.find(@teams, (team) -> team.name is selected)

    # filter games where the team isn't playing
    games = _.filter(@games, (game) -> game.away_id == team.id || game.home_id == team.id)

    # filter games that aren't over
    games = _.filter(games, (game) => moment.utc() < moment.utc(game.start_time).add(@timeCap, 'minutes'))
    games = _.sortBy(games, (game) -> game.start_time)

    nextOrCurrentGame = games[0]

    if nextOrCurrentGame
      field = _.find(@fields, (field) -> field.id == nextOrCurrentGame.field_id)
      gameTime = moment.utc(nextOrCurrentGame.start_time).format('h:mm')
      @findText = "#{team.name} @ #{gameTime}"
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
  showScheduleScreen: ->
    @scheduleScreen = true
    nodes = $('.divider-container')

    # unless scrolled set already? (try and remember scroll if they leave this page)
    if true
      # ensure scroll has run at least once so scroll buffer is resolved
      @_scrollSchedule(nodes[0])

      nowNode = _.find(nodes, (node) ->
        timeString = $(node).find('.divider-time').data('time')
        moment.utc() < moment.utc(timeString).add(@timeCap, 'minutes')
      )

      @_scrollSchedule(nowNode)

    Twine.refresh()

  _scrollSchedule: (node) ->
    $('.left-screen > .content').scrollTo(node).offset({top: 88}) # 2 x $bar-base-height

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
