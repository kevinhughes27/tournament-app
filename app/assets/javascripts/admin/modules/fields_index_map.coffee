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

  _drawFields: ->
    @_drawField(field) for field in @fields

  _drawField: (field) ->
    return unless field.geoJson
    geoJson = JSON.parse(field.geoJson)

    layers = L.geoJson(geoJson, {
      style: Admin.FieldStyle
    }).addTo(@map)

    layers.eachLayer (layer) ->
      layer.on 'click', -> Turbolinks.visit("fields/#{field.id}")
      layer.on 'mouseover', (e) -> layer.setStyle(Admin.FieldHoverStyle)
      layer.on 'mouseout', (e) -> layer.setStyle(Admin.FieldStyle)
