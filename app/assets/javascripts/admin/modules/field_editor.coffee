class Admin.FieldEditor
  LAT_FIELD: '#field_lat'
  LONG_FIELD: '#field_long'
  GEO_JSON_FIELD: '#field_geo_json'

  constructor: (lat, long, zoom, @geoJson)->
    @center = new L.LatLng(lat, long)
    @map = UT.Map(@center, zoom, true)
    @historyBuffer = []

    if @geoJson
      @_drawField()
      @historyBuffer.push({center: @center, geoJson: @geoJson})
    else
      @map.on 'mouseover', @_initDrawingMode

    @undoControl = new Admin.MapUndoControl(undoCallback: @_undoHandler)
    @map.addControl(@undoControl)

    @map.on 'editable:drawing:clicked', @_autoFinishHandler
    @map.on 'editable:drawing:commit', @_updateField
    @map.on 'editable:vertex:dragend', @_updateField
    $(document).on 'keydown', @_keyHandler

  # sets leaflet in drawing mode if we don't have a drawing yet
  # can still pan the map using the middle mouse
  _initDrawingMode: =>
    return if @historyBuffer.length >= 1
    @map.editTools.startPolygon()

  # auto complete the polygon on the 4th vertex
  _autoFinishHandler: (e) ->
    if e.layer.getLatLngs()[0].length == 4
      e.editTools.commitDrawing()
      e.layer.setStyle(Admin.FieldStyle)

  # draw a field we've previously saved
  _drawField: ->
    @layers = L.geoJson(@geoJson, {
      style: Admin.FieldStyle
    }).addTo(@map)

    @layers.eachLayer (layer) ->
      layer.enableEdit()

  _clearField: ->
    @map.editTools.featuresLayer.clearLayers() # if drawn new
    @layers.clearLayers() if @layers # if drawn from db

  # map edited event handler
  _updateField: (event) =>
    @map.removeControl(@drawingControls) if @drawingControls
    @geoJson = event.layer.toGeoJSON()
    @center = event.layer.getCenter()
    @historyBuffer.push({center: @center, geoJson: @geoJson})
    @_updateForm()

  # update the form with the map info
  _updateForm: ->
    $(@GEO_JSON_FIELD).val( JSON.stringify(@geoJson) )
    $(@LAT_FIELD).val(@center.lat)
    $(@LONG_FIELD).val(@center.lng)

  _keyHandler: (e) =>
    ESC = 27
    Z = 90

    if e.keyCode == Z && e.ctrlKey
      @_undoHandler()

    if e.keyCode == ESC
      @_cancelDrawing()

  _undoHandler: =>
    return if @historyBuffer.length == 1

    @historyBuffer.pop()
    console.log("Map History Buffer size: #{@historyBuffer.length}")

    @center = _.last(@historyBuffer).center
    @geoJson = _.last(@historyBuffer).geoJson

    @_clearField()
    @_drawField()
    @_updateForm()

  _cancelDrawing: ->
    @map.editTools.stopDrawing()
    @_clearField()
    @map.editTools.startPolygon()
