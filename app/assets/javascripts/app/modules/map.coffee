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
    return unless field.geo_json
    geoJson = JSON.parse(field.geo_json)

    layers = L.geoJson(geoJson, {
      style: App.FieldStyle
    }).addTo(@map)

  centerMap: ->
    @map.panTo(@center)

  addMarker: (lat, lng) ->
    @marker = L.marker([lat, lng], {icon: @_markerIcon()}).addTo(@map)

  _markerIcon: ->
    @markerIcon ||= L.icon({
      iconUrl: 'images/fa-map-marker.svg',
      iconSize: [42, 26],
      iconAnchor: [21, 24]
    })

  drawPointer: (lat, lng, rotation) ->
    @clearPointer()
    @pointer = L.marker([lat, lng], {icon: @_pointerIcon(), rotationAngle: rotation}).addTo(@map)

  _pointerIcon: ->
    @pointerIcon ||= L.icon({
      iconUrl: 'images/orientation-pointer.svg',
      iconSize: [39, 27],
      iconAnchor: [19, 33]
    })

  clearPointer: ->
    @map.removeLayer(@pointer) if @pointer

  clearMarkers: ->
    @map.removeLayer(@marker) if @marker
