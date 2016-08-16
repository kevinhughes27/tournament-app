import _last from 'lodash/last';
import {LatLng, geoJson} from 'leaflet';

import Map from './map';
import MapUndoControl from './map_undo_control';
import {FieldStyle, FieldHoverStyle, OtherFieldStyle} from './field_styles';

const LAT_FIELD = '#field_lat';
const LONG_FIELD = '#field_long';
const GEO_JSON_FIELD = '#field_geo_json';

class FieldEditor {
  constructor(zoom, mapLat, mapLong, field, fields) {
    this.field = field;
    this.lat = this.field.lat || mapLat;
    this.long = this.field.long || mapLong;
    this.geoJson = this.field.geo_json ? JSON.parse(this.field.geo_json) : null;
    this.center = new LatLng(this.lat, this.long);
    this.map = Map(this.center, zoom, {}, true);
    this.historyBuffer = [];

    this._drawOtherFields(fields);
    this._initializeEventHandlers();
    this._initializeUndo();
  }

  _initializeEventHandlers() {
    let isNewField = (!this.geoJson);

    if(isNewField) {
      this.map.on('mouseover', this._initDrawingMode.bind(this));
      this.map.on('contextmenu', this._initDrawingModeMobile.bind(this));
      this.map.on('editable:drawing:clicked', this._autoFinishHandler.bind(this));
      this.map.on('editable:drawing:commit', this._updateField.bind(this));
    } else {
      this._drawField();
      this.historyBuffer.push({center: this.center, geoJson: this.geoJson});
    }

    this.map.on('editable:vertex:dragend', this._updateField.bind(this));
    this.map.on('editable:vertex:rawclick', (e) => e.cancel()); //prevent vertex delete

    $(document).on('keydown', this._keyHandler.bind(this));
  }

  _initializeUndo() {
    let undoControl = new MapUndoControl({undoCallback: this._undoHandler.bind(this)});
    this.map.addControl(undoControl);
  }

  // draw a field we've previously saved
  _drawField() {
    this.layers = geoJson(this.geoJson, {
      style: FieldStyle
    }).addTo(this.map);

    this.layers.eachLayer((layer) => layer.enableEdit());
  }

  _drawOtherFields(fields) {
    fields.forEach((field) => this._drawOtherField(field));
  }

  _drawOtherField(field) {
    if(field.id == this.field.id) return;
    if(!field.geo_json) return;

    let json = JSON.parse(field.geo_json);

    geoJson(json, {
      style: OtherFieldStyle
    }).addTo(this.map);
  }

  // sets leaflet in drawing mode if we don't have a drawing yet
  // can still pan the map using the middle mouse
  _initDrawingMode() {
    if(this.historyBuffer.length >= 1) return;
    this.map.editTools.startPolygon();
  }

  _initDrawingModeMobile(event) {
    if(this.historyBuffer.length >= 1) return;
    this.map.editTools.startPolygon(event.latlng);
    if(window.canVibrate) navigator.vibrate(50);
  }

  // auto complete the polygon on the 4th vertex
  _autoFinishHandler(e) {
    if(e.layer.getLatLngs()[0].length == 4) {
      e.editTools.commitDrawing();
      e.layer.setStyle(FieldStyle);
      this.map.off('editable:drawing:clicked', this._autoFinishHandler);
    }
  }

  // map edited event handler
  _updateField(event) {
    this.geoJson = event.layer.toGeoJSON();
    this.center = event.layer.getCenter();

    this.historyBuffer.push({center: this.center, geoJson: this.geoJson});
    console.log(`Map History Buffer size: ${this.historyBuffer.length}`);

    this._updateForm();
  }

  // update the form with the map info
  _updateForm() {
    $(GEO_JSON_FIELD).val( JSON.stringify(this.geoJson) );
    $(LAT_FIELD).val(this.center.lat);
    $(LONG_FIELD).val(this.center.lng);
  }

  _keyHandler(e) {
    let ESC = 27;
    let Z = 90;

    if(e.keyCode == Z && e.ctrlKey) { this._undoHandler() }
    if(e.keyCode == ESC) { this._cancelDrawing() }
  }

  _undoHandler() {
    if(this.historyBuffer.length <= 1) return;

    this.historyBuffer.pop();
    console.log(`Map History Buffer size: ${this.historyBuffer.length}`);

    this.center = _last(this.historyBuffer).center;
    this.geoJson = _last(this.historyBuffer).geoJson;

    this._clearField();
    this._drawField();
    this._updateForm();
  }

  _cancelDrawing() {
    this.map.editTools.stopDrawing();
    this._clearField();
    this.map.editTools.startPolygon();
  }

  _clearField() {
    this.map.editTools.featuresLayer.clearLayers(); //if drawn new
    if(this.layers) this.layers.clearLayers(); //if drawn from db
  }
}

module.exports = FieldEditor;
