Admin.MapUndoControl = L.Control.extend({

  options: {
    position: 'topleft'
  },

  initialize: (options) ->
    L.Util.setOptions(this, options);

  onAdd: (map) ->
    container = L.DomUtil.create('div', 'leaflet-control leaflet-bar')

    link = L.DomUtil.create('a', '', container)
    link.href = '#'
    link.title = 'Undo'
    link.innerHTML = '<i class="fa fa-undo"></i>'

    L.DomEvent.on(link, 'click', L.DomEvent.stop)
              .on(link, 'click', => @options.undoCallback())

    container
})
