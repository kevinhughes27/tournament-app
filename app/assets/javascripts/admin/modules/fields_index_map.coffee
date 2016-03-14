class Admin.FieldsIndexMap extends UT.MapForm
  DEFAULT_ZOOM: 15

  constructor: (@$form, lat, long, zoom, @fields) ->
    super
    @_constructor()

  _constructor: ->
    @_drawFields()

    $('body').on 'shown.bs.tab', (e) =>
      if e.target.hash == '#map'
        @map.invalidateSize(false)

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

  _drawFields: ->
    @_drawField(field) for field in @fields

  _drawField: (field) ->
    return unless field.geoJson
    geoJson = JSON.parse(field.geoJson)

    layers = L.geoJson(geoJson, {
      style: Admin.FieldStyle
    }).addTo(@map)

    layers.eachLayer (layer) ->
      layer.on 'click', -> Admin.Redirect("fields/#{field.id}")
      layer.on 'mouseover', (e) -> layer.setStyle(Admin.FieldHoverStyle)
      layer.on 'mouseout', (e) -> layer.setStyle(Admin.FieldStyle)
