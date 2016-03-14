window.UT ||= {}

class UT.MapForm
  LAT_FIELD: '#tournament_map_attributes_lat'
  LONG_FIELD: '#tournament_map_attributes_long'
  ZOOM_FIELD: '#tournament_map_attributes_zoom'

  constructor: (@$form, lat, long, zoom) ->
    center = new L.LatLng(lat, long)
    @map = UT.Map(center, zoom)

    @historyBuffer = [{lat: lat, lng: long, zoom: zoom}]

    @placesSearch = new UT.PlacesSearch(@placesSearchChange)

    @undoControl = new Admin.MapUndoControl(undoCallback: @_undoHandler)
    @map.addControl(@undoControl)

    @map.on "drag", @_updateForm
    @map.on "dragend", @_updateHistory

    @map.on "zoom", @_updateForm
    @map.on "zoomend", @_updateHistory

    $(@LAT_FIELD).on 'change', @_updateMap
    $(@LONG_FIELD).on 'change', @_updateMap
    $(@ZOOM_FIELD).on 'change', @_updateMap

    @$form.on 'submit', @submit
    @$form.on 'keypress', (e) -> return false if e.which == 13 # don't submit for enter press

  placesSearchChange: (place) =>
    if viewport = place.geometry.viewport?.toJSON()
      @map.fitBounds([
        [viewport.south, viewport.west],
        [viewport.north, viewport.east]
      ])
    else
      lat = place.geometry.location.lat()
      lng = place.geometry.location.lng()
      @map.setView([lat, lng], @DEFAULT_ZOOM)

    @_updateForm()

  submit: (ev) =>
    ev.preventDefault()

    $.ajax
      type: 'PUT'
      url: @$form.attr('action')
      data: @$form.serialize()
      success: ->
        $('.btn').removeClass('is-loading')
        Admin.Flash.notice('Map saved.')
      error: ->
        $('.btn').removeClass('is-loading')
        Admin.Flash.error('Error saving Map.')

  _updateForm: =>
    center = @map.getCenter()
    zoom = @map.getZoom()

    $(@LAT_FIELD).val(center.lat)
    $(@LONG_FIELD).val(center.lng)
    $(@ZOOM_FIELD).val(zoom)

  _updateHistory: =>
    center = @map.getCenter()
    zoom = @map.getZoom()

    @historyBuffer.push({lat: center.lat, lng: center.lng, zoom: zoom})

  _updateMap: =>
    lat = $(@LAT_FIELD).val()
    lng = $(@LONG_FIELD).val()
    zoom = $(@ZOOM_FIELD).val()

    @map.setView([lat, lng], zoom)

  _undoHandler: =>
    return if @historyBuffer.length == 1

    @historyBuffer.pop()
    console.log("Map History Buffer size: #{@historyBuffer.length}")

    lat = _.last(@historyBuffer).lat
    lng = _.last(@historyBuffer).lng
    zoom = _.last(@historyBuffer).zoom

    @map.setView([lat, lng], zoom)
    $(@LAT_FIELD).val(lat)
    $(@LONG_FIELD).val(lng)
    $(@ZOOM_FIELD).val(zoom)
