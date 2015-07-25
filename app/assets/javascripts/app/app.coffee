class TournamentApp.App

  constructor: (@tournmanentLocation, @zoom, @fields, @teams, @games, @timeCap, @mapMarkerSvg) ->
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

    @initApp()

  mainScreen: ->
    !@scheduleScreen && !@submitScoreScreenA && !@submitScoreScreenB

  initializeMap: =>
    @mapNode = document.getElementById('map-canvas')

    @map = new google.maps.Map(@mapNode, {
      zoom: @zoom,
      center: new google.maps.LatLng(@tournmanentLocation...),
      mapTypeId: google.maps.MapTypeId.SATELLITE
      disableDefaultUI: true
    })

    @drawFields()
    @markers = []

    google.maps.event.addListenerOnce @map, 'tilesloaded', =>
      $('.loading-gif').fadeOut(1000)

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

  addMarker: (lat, lng, title) ->
    latLng = new google.maps.LatLng(lat, lng)

    @markers.push new google.maps.Marker(
      title: title,
      position: latLng,
      map: @map,
      icon: {
        url: @mapMarkerSvg,
        strokeColor: "#FFFFFF",
      }
    )

  drawPointer: (lat, lng, rotation, title) ->
    @pointer ?= new google.maps.Marker(title: title, map: @map)
    @pointer.setPosition( new google.maps.LatLng(lat, lng) )
    @pointer.setIcon({
      path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
      strokeColor: "#FFFFFF",
      strokeWeight: 2,
      fillColor: '#FFFFFF',
      fillOpacity: 1,
      scale: 4,
      rotation: rotation,
    })

  clearPointer: ->
    @pointer.setMap(null) if @pointer
    @pointer = null

  clearMarkers: ->
    marker.setMap(null) for marker in @markers
    @markers = []

  initApp: ->
    @pointMeThere = new TournamentApp.PointMeThere()

    # node = $('#app')[0]
    # @hammertime = new Hammer(node)
    #
    # @hammertime.on 'panright', (event) =>
    #   return unless @mainScreen()
    #   @scheduleScreen = true
    #   Twine.refresh()
    #
    # @hammertime.on 'panleft', (event) =>
    #   return unless @mainScreen()
    #   @submitScoreScreenA = true
    #   Twine.refresh()

    @fingerprint = new Fingerprint2()
    @fingerprint.get (result) ->
      $('input#submitter_fingerprint').val(result)

    window.addEventListener "hashchange", (event) =>
      # back button pretty much just resets to main
      if location.hash == ""
        @scheduleScreen = false
        @submitScoreScreenA = false
        @submitScoreScreenB = false
        Twine.refresh()

  showFieldSelect: =>
    @fieldSearchOpen = true
    @teamSearchOpen = false
    @drawerOpen = false
    @finishPointToField()
    Twine.refresh()
    _.defer -> $('#main-field-search').focus()

  showTeamSelect: =>
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
    games = _.filter(games, (game) => moment.utc() < moment.utc(game.start_time).add(@timeCap, 'minutes'))
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

  getFindText: ->
    @findText

  pointToField: (field) ->
    @findingField = true
    @tooFarAlert = false

    @clearMarkers()
    @addMarker(field.lat, field.long, field.name)

    @pointMeThere.setDestination(field.lat, field.long, field.name)
    @pointMeThere.start (event) => _.throttle(@_pointToFieldCallback(event), 500)

  _pointToFieldCallback: (event) ->
    bounds = new google.maps.LatLngBounds()
    destination = new google.maps.LatLng(event.dstLat, event.dstLng)
    bounds.extend(destination)

    if event.distance > 1000
      alert("You're too far away!") unless @tooFarAlert
      @tooFarAlert = true
    else if event.lat && event.long
      @drawPointer(event.lat, event.long, event.heading, 'Location')
      location = new google.maps.LatLng(event.lat, event.long)
      bounds.extend(location)

    @map.panToBounds(bounds)
    @map.setZoom(@zoom) if @map.getZoom() > @zoom

  finishPointToField: ->
    @findingField = false
    @clearMarkers()
    @clearPointer()
    @centerMap()
    Twine.refresh()


  # Schedule view
  showScheduleScreen: ->
    @scheduleScreen = true
    location.hash = "schedule"
    # unless @scheduleScrolled
    #   # only run this once. then remember the users scroll
    #   @scheduleScrolled = true
    #
    #   # ensure scroll has run at least once so scroll buffer is resolved
    #   nodes = $('.divider-container')
    #   @_scrollSchedule(nodes[0])
    #
    #   nowNode = _.find(nodes, (node) ->
    #     timeString = $(node).find('.divider-time').data('time')
    #     moment.utc() < moment.utc(timeString).add(@timeCap, 'minutes')
    #   )
    #
    #   @_scrollSchedule(nowNode)
    Twine.refresh()

  # _scrollSchedule: (node) ->
  #   $('.left-screen > .content').scrollTo(node).offset({top: 88}) # 2 x $bar-base-height

  closeScheduleScreen: ->
    @scheduleScreen = false
    location.hash = ""
    Twine.refresh()

  scheduleSearchChange: (event)->
    @lastScheduleSearch = $.trim( $(event.target).val() )
    Twine.refresh()

  scheduleFilter: (teamNames) ->
    if @lastScheduleSearch
      # prevent accidently matching a substring
      teamNames.join(',').match("#{@lastScheduleSearch} vs") || teamNames.join(',').endsWith("vs #{@lastScheduleSearch}")
    else
      true

  findField: (fieldName) ->
    @scheduleScreen = false
    field = _.find(@fields, (field) -> field.name is fieldName)

    if field
      @findText = "#{field.name}"
      @pointToField(field)

    Twine.refresh()


  # Submit score A view
  showSubmitScoreScreen: ->
    @submitScoreScreenA = true
    location.hash = "submit-score"
    Twine.refresh()

  closeSubmitScoreScreen: ->
    @submitScoreScreenA = false
    location.hash = ""
    Twine.refresh()

  submitSearchChange: (event) ->
    @lastSubmitSearch = $.trim( $(event.target).val() )
    Twine.refresh()

  submitFilter: (teamNames) ->
    if @lastSubmitSearch
      # prevent accidently matching a substring
      teamNames.join(',').match("#{@lastSubmitSearch} vs") || teamNames.join(',').endsWith("vs #{@lastSubmitSearch}")

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
