import * as Leaflet from 'leaflet';
import { FieldStyle } from './FieldStyle';

const style = () => FieldStyle;

class EditableField {
  layers?: Leaflet.LayerGroup<Leaflet.ILayer>;

  update(map: Leaflet.Map, geoJson: any) {
    this.layers = Leaflet.geoJson(geoJson, { style }).addTo(map);

    this.layers.eachLayer(layer => {
      const polygon = layer as Leaflet.Polygon;
      polygon.enableEdit();
    });
  }

  clear = () => {
    if (this.layers) {
      this.layers.clearLayers();
    }
  };

  getCenter = () => {
    const mainLayer = this.layers!.getLayers()[0];
    const editPolygon = mainLayer as Leaflet.Polygon;
    return editPolygon.getBounds().getCenter();
  };
}

const editableField = new EditableField();

export default editableField;
