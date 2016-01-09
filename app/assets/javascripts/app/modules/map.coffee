class App.Map

  constructor: (@app, lat, long, zoom) ->
    @center = new L.LatLng(lat, long)
    @map = UT.Map(@center, zoom, {zoomControl: false})
    @_drawFields()

    @map.on 'load', ->
      $('.loading-gif').fadeOut(1000)

  _drawFields: ->
    @_drawField(field) for field in @app.fields

  _drawField: (field) ->
    geoJson = JSON.parse(field.geo_json)

    layers = L.geoJson(geoJson, {
      style: App.FieldStyle
    }).addTo(@map)

  centerMap: ->
    @map.panTo(@center)

  addMarker: (lat, lng) ->
    @marker = L.marker([lat, lng], {icon: @_markerIcon()}).addTo(@map)
    # latLng = new google.maps.LatLng(lat, lng)
    #
    # @markers.push new google.maps.Marker(
    #   title: title,
    #   position: latLng,
    #   map: @map,
    #   icon: {
    #     url: @markerSvg,
    #     strokeColor: "#FFFFFF",
    #   }
    # )

    #####
    # http://leafletjs.com/examples/custom-icons.html

  _markerIcon: ->
    @markerIcon ||= L.icon({
      iconUrl: 'images/fa-map-marker.svg',
    })

  drawPointer: (lat, lng, rotation) ->
    @clearPointer()
    @pointer = L.marker([lat, lng], {icon: @_pointerIcon(), rotationAngle: rotation}).addTo(@map)
    # @pointer ?= new google.maps.Marker(title: title, map: @map)
    # @pointer.setPosition( new google.maps.LatLng(lat, lng) )
    # @pointer.setIcon({
    #   path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
    #   strokeColor: "#FFFFFF",
    #   strokeWeight: 2,
    #   fillColor: '#FFFFFF',
    #   fillOpacity: 1,
    #   scale: 4,
    #   rotation: rotation,
    # })

  _pointerIcon: ->
    @pointerIcon ||= L.icon({
      iconUrl: 'images/orientation-pointer.svg',
    })

  clearPointer: ->
    @map.removeLayer(@pointer) if @pointer
    # @pointer.setMap(null) if @pointer
    # @pointer = null

  clearMarkers: ->
    @map.removeLayer(@marker) if @marker
    # marker.setMap(null) for marker in @markers
    # @markers = []
