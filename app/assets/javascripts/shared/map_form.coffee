window.UT ||= {}

class UT.MapForm
  LAT_FIELD: '#tournament_map_attributes_lat'
  LONG_FIELD: '#tournament_map_attributes_long'
  ZOOM_FIELD: '#tournament_map_attributes_zoom'

  constructor: (lat, long, @zoom) ->
    @center = new L.LatLng(lat, long)
    @map = UT.Map(@center, @zoom)

    @markersLayer = new L.LayerGroup()
    @map.addLayer(@markersLayer)

    @map.addControl(@_searchControl())

    @map.on "drag", @_updateForm
    @map.on "zoom", @_updateForm

    $(@LAT_FIELD).on 'change', @_updateMap
    $(@LONG_FIELD).on 'change', @_updateMap
    $(@ZOOM_FIELD).on 'change', @_updateMap

  _searchControl: ->
    new L.Control.Search({
      url: 'http://nominatim.openstreetmap.org/search?format=json&q={s}',
      jsonpParam: 'json_callback',
      propertyName: 'display_name',
      propertyLoc: ['lat','lon'],
      position: 'topleft'
      circleLocation: false,
      markerLocation: false,
      markerIcon: false,
      autoType: false,
      autoCollapse: true,
      minLength: 2
    })

  _updateForm: =>
    @center = @map.getCenter()
    @zoom = @map.getZoom()

    $(@LAT_FIELD).val(@center.lat)
    $(@LONG_FIELD).val(@center.lng)
    $(@ZOOM_FIELD).val(@zoom)

  _updateMap: =>
    lat = $(@LAT_FIELD).val()
    lng = $(@LONG_FIELD).val()
    zoom = $(@ZOOM_FIELD).val()
    @map.setView([lat, lng], zoom)
