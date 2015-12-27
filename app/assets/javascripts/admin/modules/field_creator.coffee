class Admin.FieldCreator

  constructor: (lat, long, zoom, @fields) ->
    @map = L.map('map', {
      center: new L.LatLng(lat, long),
      zoom: zoom
    })

    @_addMapTileLayer()
    @_drawFields()

  _addMapTileLayer: ->
    googleSat = L.tileLayer('http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
      maxZoom: 20,
      subdomains:['mt0','mt1','mt2','mt3']
    })
    @map.addLayer(googleSat)

  _drawFields: ->
    for field in @fields
      @_drawField(field)

  _drawField: (field) ->
    polygon = JSON.parse(field.polygon)

    # fix old google maps polygons
    if polygon[0].A
      new_poly = []
      for pt in polygon
        new_poly.push({lat: pt.A, lng: pt.F})
      polygon = new_poly

    poly = L.polygon(polygon).addTo(@map)

    poly.on 'click', -> Admin.Redirect("/fields/#{field.id}")
