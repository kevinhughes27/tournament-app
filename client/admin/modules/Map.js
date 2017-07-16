import _extend from 'lodash/extend'
import {map, tileLayer} from 'leaflet'
import 'leaflet-editable'

module.exports = function (center, zoom, options = {}, editable = false) {
  options = _extend(options, {
    center: center,
    zoom: zoom,
    doubleClickZoom: false,
    attributionControl: false
  })

  if (editable) {
    options = _extend(options, {
      editable: true,
      editOptions: {
        skipMiddleMarkers: true
      }
    })
  }

  let m = map('_map', options)

  let googleSat = tileLayer('https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
    maxZoom: 20,
    subdomains: ['mt0', 'mt1', 'mt2', 'mt3']
  })

  m.addLayer(googleSat)

  return m
}
