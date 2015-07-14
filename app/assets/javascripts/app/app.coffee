class TournamentApp.App

  constructor: (@tournmanentLocation, @zoom, @fields, @teams, @games) ->
    @drawerOpen = false
    @modalOpen = false
    @searchOpen = false
    @scheduleScreen = false
    @submitScoreScreen = false

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
      fillColor: '#7FC013'
    )

    field.shape = polygon
    polygon.setMap(@map)

  initApp: ->
    @_initSelectize()
    pointMeThere = $('#point-me-there')
    @pointMeThere = new TournamentApp.PointMeThere(pointMeThere)

  _initSelectize: ->
    $selectNode = $('select#main-search')
    $selectNode.selectize(valueField: 'name', labelField: 'name', searchField: 'name')
    @selectize = $selectNode[0].selectize
    @selectize.on 'blur', (event) =>
      @searchOpen = false
      Twine.refresh()

  showFieldSelect: =>
    @_selectizeUpdate(@fields)
    @_selectedCallback = @_fieldSelected
    @searchOpen = true
    @drawerOpen = false
    Twine.refresh()
    @selectize.focus()

  showTeamSelect: =>
    @_selectizeUpdate(@teams)
    @_selectedCallback = @_teamSelected
    @searchOpen = true
    @drawerOpen = false
    Twine.refresh()
    @selectize.focus()

  _selectizeUpdate: (options) ->
    @selectize.clearOptions()
    @selectize.addOption(options)
    @selectize.refreshOptions(false)

  selectedCallback: (event) =>
    selected = $(event.target).val()
    @selectize.blur()
    @_selectedCallback(selected)

  _fieldSelected: (selected) =>
    @searchOpen = false
    field = _.find(@fields, (field) -> field.name is selected)

    if field
      @pointMeThere.setDestination(field.lat, field.long, field.name)
      @pointMeThere.start()
      @modalOpen = true

    Twine.refresh()

  _teamSelected: (selected) =>
    @searchOpen = false
    team = _.find(@teams, (team) -> team.name is selected)
    games = _.filter(@games, (game) -> game.away_id == team.id || game.home_id == team.id)
    games = _.sortBy(games, (game) -> game.start_time)
    cutOffIdx = _.findIndex(games, (game) -> Date.parse(game.start_time) > Date.now())
    # cut off is all games with start time ahead of time now.
    # I could rewind this by one which is *likey* the current game.
    # Games should have a duration (tournaments have hard cap so why not give them that?)

    currentGame = games[cutOffIdx - 1]
    field = _.find(@fields, (field) -> field.id == currentGame.field_id)

    if field
      @pointMeThere.setDestination(field.lat, field.long, field.name)
      @pointMeThere.start()
      @modalOpen = true

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
