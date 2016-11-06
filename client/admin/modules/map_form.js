import _last from 'lodash/last'
import {LatLng, geoJson} from 'leaflet'

import Map from './map'
import MapUndoControl from './map_undo_control'
import {FieldStyle, FieldHoverStyle} from './field_styles'

const LAT_FIELD = '#tournament_map_attributes_lat'
const LONG_FIELD = '#tournament_map_attributes_long'
const ZOOM_FIELD = '#tournament_map_attributes_zoom'
const DEFAULT_ZOOM = 14

class MapForm {
  constructor ($form, lat, long, zoom, fields) {
    this.$form = $form
    let center = new LatLng(lat, long)
    this.map = Map(center, zoom)
    this.historyBuffer = [{lat: lat, lng: long, zoom: zoom}]

    this._initializeEventHandlers()
    this._initializeUndo()
    this._initializeSearch()
    this._drawFields(fields)
  }

  _initializeEventHandlers () {
    this.map.on('drag', this._updateForm.bind(this))
    this.map.on('dragend', this._updateHistory.bind(this))

    this.map.on('zoom', this._updateForm.bind(this))
    this.map.on('zoomend', this._updateHistory.bind(this))

    $(LAT_FIELD).on('change', this._updateMap.bind(this))
    $(LONG_FIELD).on('change', this._updateMap.bind(this))
    $(ZOOM_FIELD).on('change', this._updateMap.bind(this))

    this.$form.on('submit', this.submit.bind(this))

    // don't submit for enter press
    this.$form.on('keypress', (e) => { if (e.which === 13) return false })
  }

  _initializeUndo () {
    let undoControl = new MapUndoControl({undoCallback: this._undoHandler.bind(this)})
    this.map.addControl(undoControl)
  }

  _initializeSearch () {
    new UT.PlacesSearch(this.placesSearchChange.bind(this))
  }

  _drawFields (fields) {
    fields.forEach((field) => this._drawField(field))
  }

  _drawField (field) {
    if (!field.geoJson) return

    let json = JSON.parse(field.geoJson)

    let layers = geoJson(json, {
      style: FieldStyle
    }).addTo(this.map)

    layers.eachLayer(function (layer) {
      layer.on('click', () => Turbolinks.visit(`fields/${field.id}`))
      layer.on('mouseover', (e) => layer.setStyle(FieldHoverStyle))
      layer.on('mouseout', (e) => layer.setStyle(FieldStyle))
    })
  }

  placesSearchChange (place) {
    let viewport = place.geometry.viewport

    if (viewport) {
      viewport = viewport.toJSON()
      this.map.fitBounds([
        [viewport.south, viewport.west],
        [viewport.north, viewport.east]
      ])
    } else {
      let lat = place.geometry.location.lat()
      let lng = place.geometry.location.lng()
      this.map.setView([lat, lng], DEFAULT_ZOOM)
    }

    this._updateForm()
  }

  submit (ev) {
    ev.preventDefault()

    $.ajax({
      type: 'PUT',
      url: this.$form.attr('action'),
      data: this.$form.serialize(),
      success: () => {
        $('.btn').removeClass('is-loading')
        Admin.Flash.notice('Map saved.')
      },
      error: () => {
        $('.btn').removeClass('is-loading')
        Admin.Flash.error('Error saving Map.')
      }
    })
  }

  _updateForm () {
    let center = this.map.getCenter()
    let zoom = this.map.getZoom()

    $(LAT_FIELD).val(center.lat)
    $(LONG_FIELD).val(center.lng)
    $(ZOOM_FIELD).val(zoom)
  }

  _updateHistory () {
    let center = this.map.getCenter()
    let zoom = this.map.getZoom()

    this.historyBuffer.push({lat: center.lat, lng: center.lng, zoom: zoom})
  }

  _updateMap () {
    let lat = $(LAT_FIELD).val()
    let lng = $(LONG_FIELD).val()
    let zoom = $(ZOOM_FIELD).val()

    this.map.setView([lat, lng], zoom)
  }

  _undoHandler () {
    if (this.historyBuffer.length === 1) return

    this.historyBuffer.pop()
    console.log(`Map History Buffer size: ${this.historyBuffer.length}`)

    let lat = _last(this.historyBuffer).lat
    let lng = _last(this.historyBuffer).lng
    let zoom = _last(this.historyBuffer).zoom

    this.map.setView([lat, lng], zoom)
    $(LAT_FIELD).val(lat)
    $(LONG_FIELD).val(lng)
    $(ZOOM_FIELD).val(zoom)
  }
}

module.exports = MapForm
