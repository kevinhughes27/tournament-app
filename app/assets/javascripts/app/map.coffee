class App.Map

  constructor: (@app, @center, @zoom, @markerSvg) ->
    window.mapCallback = @mapCallback
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=drawing&callback=mapCallback'
    document.body.appendChild(script)

  mapCallback: =>
    @mapNode = document.getElementById('map-canvas')

    @map = new google.maps.Map(@mapNode, {
      mapTypeId: google.maps.MapTypeId.SATELLITE
      disableDefaultUI: true
    })

    @centerMap()
    @drawFields()
    @markers = []

    google.maps.event.addListenerOnce @map, 'tilesloaded', =>
      $('.loading-gif').fadeOut(1000)

  centerMap: ->
    @map.setCenter(new google.maps.LatLng(@center...))
    @map.setZoom(@zoom)

  drawFields: ->
    for field in @app.fields
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
        url: @markerSvg,
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
