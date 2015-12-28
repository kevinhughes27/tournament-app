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
    geoJson = JSON.parse(field.geo_json)
    layers = L.geoJson(geoJson).addTo(@map)
    layers.eachLayer (layer) ->
      layer.on 'click', -> Admin.Redirect("/fields/#{field.id}")
      layer.on 'mouseover', (e) ->
        layer = e.target
        layer.setStyle({
            weight: 5,
            color: '#666',
            dashArray: '',
            fillOpacity: 0.7
        })
