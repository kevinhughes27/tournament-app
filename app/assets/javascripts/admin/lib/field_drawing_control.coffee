Admin.FieldControl = L.Control.extend({
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

    container
})
