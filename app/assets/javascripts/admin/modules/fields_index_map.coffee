class Admin.FieldsIndexMap

  constructor: (lat, long, zoom, @fields) ->
    @center = new L.LatLng(lat, long)
    @map = Admin.Map(@center, zoom)
    @_drawFields()

    $('body').on 'shown.bs.tab', (e) =>
      if e.target.hash == '#map-tab'
        @map.invalidateSize(false)

  _drawFields: ->
    @_drawField(field) for field in @fields

  _drawField: (field) ->
    geoJson = JSON.parse(field.geo_json)

    layers = L.geoJson(geoJson, {
      style: Admin.FieldStyle
    }).addTo(@map)

    layers.eachLayer (layer) ->
      layer.on 'click', -> Admin.Redirect("fields/#{field.id}")
      layer.on 'mouseover', (e) -> layer.setStyle(Admin.FieldHoverStyle)
      layer.on 'mouseout', (e) -> layer.setStyle(Admin.FieldStyle)
