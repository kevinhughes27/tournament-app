class Admin.FieldEditor
  LAT_FIELD: '#field_lat'
  LONG_FIELD: '#field_long'
  GEO_JSON_FIELD: '#field_geo_json'

  constructor: (lat, long, zoom, @geoJson)->
    @map = L.map('map', {
      center: new L.LatLng(lat, long),
      zoom: zoom,
      editable: true
    })

    @_addMapTileLayer()
    @_drawField()

    @_addMapDrawingControls() unless @geoJson

    @map.on 'editable:drawing:commit', @_updateField
    @map.on 'editable:vertex:dragend', @_updateField

  _addMapTileLayer: ->
    googleSat = L.tileLayer('http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
      maxZoom: 20,
      subdomains:['mt0','mt1','mt2','mt3']
    })
    @map.addLayer(googleSat)

  _addMapDrawingControls: ->
    @drawingControls = new Admin.FieldControl()
    @map.addControl(@drawingControls)

  _drawField: ->
    layers = L.geoJson(@geoJson, {
      style: Admin.FieldStyle
    }).addTo(@map)

    layers.eachLayer (layer) ->
      layer.enableEdit()

  _updateField: (event) =>
    @map.removeControl(@drawingControls) if @drawingControls

    @geoJson = event.layer.toGeoJSON()
    center = event.layer.getCenter()

    $(@GEO_JSON_FIELD).val( JSON.stringify(@geoJson) )
    $(@LAT_FIELD).val(center.lat)
    $(@LONG_FIELD).val(center.lng)
