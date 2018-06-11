import {Control, Util, DomUtil, DomEvent} from 'leaflet'

let initialize = function (options) {
  Util.setOptions(this, options)
}

let onAdd = function (map) {
  let container = DomUtil.create('div', 'leaflet-control leaflet-bar')

  let link = DomUtil.create('a', '', container)
  link.href = '#'
  link.title = 'Undo'
  link.innerHTML = `<i class="fa ${this.options.icon}"></i>`

  DomEvent.on(link, 'click', DomEvent.stop)
          .on(link, 'click', () => this.options.callback())

  return container
}

module.exports = Control.extend({
  options: {position: 'topleft'},
  initialize: initialize,
  onAdd: onAdd
})
