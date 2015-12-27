class Admin.FieldEditor
  LAT_FIELD: '#field_lat'
  LONG_FIELD: '#field_long'
  POLYGON_FIELD: '#field_polygon'

  constructor: (lat, long, @polygon, zoom)->
    @map = L.map('map', {
      center: new L.LatLng(lat, long),
      zoom: zoom,
      editable: true
    })

    @_addMapTileLayer()
    @_addMapDrawingControls()
    @_drawField()

    @map.on 'editable:drawing:commit', @_updateField
    @map.on 'editable:vertex:dragend', @_updateField

  _addMapTileLayer: ->
    googleSat = L.tileLayer('http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
      maxZoom: 20,
      subdomains:['mt0','mt1','mt2','mt3']
    })
    @map.addLayer(googleSat)

  _addMapDrawingControls: ->
    L.NewPolygonControl = L.Control.extend({
      options: {
        position: 'topleft'
      },
      onAdd: (map) ->
        container = L.DomUtil.create('div', 'leaflet-control leaflet-bar')

        link = L.DomUtil.create('a', '', container)
        link.href = '#'
        link.title = 'Create a new polygon'
        link.innerHTML = '▱'

        L.DomEvent.on(link, 'click', L.DomEvent.stop)
                  .on(link, 'click', -> map.editTools.startPolygon())

        return container
    })

    @map.addControl(new L.NewPolygonControl())

  _drawField: ->
    # fix old google maps polygons
    if @polygon[0].A
      new_poly = []
      for pt in @polygon
        new_poly.push({lat: pt.A, lng: pt.F})
      @polygon = new_poly

    poly = L.polygon(@polygon).addTo(@map)
    poly.enableEdit()

  _updateField: (event) =>
    latlngs = event.layer.editor.getLatLngs()[0]

    points = []
    for point in latlngs
      points.push({lat: point.lat, lng: point.lng})

    center = L.polygon(points).getBounds().getCenter()

    $(@POLYGON_FIELD).val( JSON.stringify(points) )
    $(@LAT_FIELD).val(center.lat)
    $(@LONG_FIELD).val(center.lng)
