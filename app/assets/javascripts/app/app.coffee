class TournamentApp.App

  constructor: (@tournmanentLocation, @zoom, @fields) ->
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
    @$findDrawer = $('#find-drawer')

    @$searchBar = $('#search-bar')

    @$selectNode = @$searchBar.find('select')
    @$selectNode.selectpicker()
    @$selectNode.on('change', @selectedCallback)

    pointMeThereModal = $('#point-me-there-modal')
    @pointMeThere = new TournamentApp.PointMeThere(pointMeThereModal)

    $('#find-field').on 'touchend', @_showFieldSelect
    $('#find-team').on 'touchend', @_showTeamSelect

  _showFieldSelect: =>
    @_selectedCallback = @_fieldSelected
    @$selectNode.empty()

    for field in @fields
      @$selectNode.append("<option value='#{field.name}'>#{field.name}</option>")

    @$selectNode.selectpicker('refresh')
    @$searchBar.removeClass('hidden')
    @$findDrawer.removeClass('active')

  _showTeamSelect: =>
    @_selectedCallback = @_teamSelected
    @$selectNode.empty()

    for team in ['Swift', 'Shrike', 'Iron Crow']
      @$selectNode.append("<option value='#{team}'>#{team}</option>")

    @$selectNode.selectpicker('refresh')
    @$searchBar.removeClass('hidden')
    @$findDrawer.removeClass('active')

  selectedCallback: (event) =>
    selected = $(event.target).val()
    @_selectedCallback(selected)

  _fieldSelected: (selected) =>
    @$searchBar.addClass('hidden')
    field = _.find(@fields, (field) -> field.name is selected)

    @pointMeThere.setDestination(field.lat, field.long, field.name)
    @pointMeThere.start()

  _teamSelected: (selected) =>
    @$searchBar.addClass('hidden')
    #ToDo lookup schedule
