import * as React from 'react';
import * as Leaflet from 'leaflet';
import { Map } from 'react-leaflet';
import FieldsEditorMap from './FieldsEditorMap';
import FieldsEditorInput from './FieldsEditorInput';
import FieldsEditorControls from './FieldsEditorControls';
import FieldsEditorActions from './FieldsEditorActions';
import FieldImport from './FieldImport';
import EditableField from './EditableField';
import UpdateMapMutation from '../../mutations/UpdateMap';
import UpdateFieldMutation from '../../mutations/UpdateField';
import CreateFieldMutation from '../../mutations/CreateField';
import DeleteFieldMutation from '../../mutations/DeleteField';
import quadrilateralise from './quadrilateralise';
import runMutation from '../../helpers/runMutation';
import { merge, omit } from 'lodash';

interface Props {
  map: FieldsEditorQuery_map;
  fields: FieldsEditorQuery['fields'];
}

type Mode = 'none' | 'view' | 'editMap' | 'addField' | 'editField';

interface State {
  mode: Mode;
  lat: number;
  long: number;
  zoom: number;
  modalOpen: boolean;
  submitting: boolean;
  editing: {
    id?: string;
    name: string;
    lat: number;
    long: number;
    geoJson: string;
  };
  nameError?: UserError;
}

const newField = {
  name: '',
  lat: 0,
  long: 0,
  geoJson: ''
};

class FieldsEditor extends React.Component<Props, State> {
  mapRef = React.createRef<Map>();
  map?: Leaflet.Map;
  historyBuffer: any[] = [];

  constructor(props: Props) {
    super(props);

    const { lat, long, zoom } = props.map;

    this.state = {
      mode: 'view',
      lat,
      long,
      zoom,
      modalOpen: false,
      submitting: false,
      editing: newField
    };
  }

  componentDidMount() {
    this.map = this.mapRef.current!.leafletElement;
    this.map!.on('editable:drawing:commit', this.updateField);
    this.map!.on('editable:vertex:dragend', this.updateField);
    this.map!.on('editable:vertex:rawclick', this.noOp); // prevent vertex delete
  }

  /* Mode change handlers */
  editMap = () => {
    const { lat, long, zoom } = this.props.map;
    this.setState({ mode: 'editMap', lat, long, zoom });
  };

  addField = () => {
    EditableField.clear();
    this.historyBuffer = [];
    this.setState({ mode: 'addField', editing: newField });

    // quick pause so touch screen doesn't register a vertex immediately
    setTimeout(() => {
      this.map!.editTools.startPolygon();
      this.map!.on('editable:drawing:clicked', this.autoComplete);
    }, 100);
  };

  editField = (field: FieldsEditorQuery_fields) => {
    const geoJson = JSON.parse(field.geoJson);
    const editing = omit(field, '__typename');

    EditableField.clear();
    EditableField.update(this.map!, geoJson);
    this.historyBuffer = [];
    this.historyBuffer.push(geoJson);
    this.setState({ mode: 'editField', editing });
  };

  cancelMode = () => {
    if (this.state.mode === 'editMap') {
      const { lat, long, zoom } = this.props.map;
      this.setState({ lat, long, zoom, mode: 'view' });
    } else {
      EditableField.clear();
      this.historyBuffer = [];
      this.setState({ mode: 'view', editing: newField });
    }
  };

  /* Leaflet event handlers */
  updateMap = (ev: any) => {
    if (ev.flyTo) {
      return;
    }

    const { lat, lng: long } = this.map!.getCenter();
    const zoom = this.map!.getZoom();
    this.setState({ lat, long, zoom });
  };

  updateField = (event: Leaflet.LeafletEvent) => {
    const polygon = (event as any).layer as Leaflet.Polygon;
    const geoJson = polygon.toGeoJSON();

    this.setEditingState(geoJson);
  };

  squareFieldCorners = () => {
    if (this.state.editing.geoJson) {
      const geoJson = JSON.parse(this.state.editing.geoJson);
      const orthGeoJson = quadrilateralise(geoJson, this.map!);

      this.setEditingState(orthGeoJson);
    }
  };

  undoEdit = () => {
    if (this.historyBuffer.length > 1) {
      this.map!.editTools.stopDrawing(); // in case un-doing a redraw
      this.historyBuffer.pop();
      const geoJson = this.historyBuffer.pop();

      this.setEditingState(geoJson);
    }
  };

  redrawField = () => {
    EditableField.clear();

    const editing = { ...this.state.editing };
    merge(editing, { lat: 0, long: 0, geoJson: '' });

    this.historyBuffer.push(this.state.editing.geoJson);
    this.setState({ editing });

    this.map!.editTools.startPolygon();
    this.map!.on('editable:drawing:clicked', this.autoComplete);
  };

  // https://github.com/Leaflet/Leaflet.Editable/blob/master/src/Leaflet.Editable.js#L389
  noOp = (event: Leaflet.LeafletEvent) => {
    (event as any).cancel();
  };

  // auto complete the polygon on the 4th vertex
  autoComplete = (event: Leaflet.LeafletEvent) => {
    const polygon = (event as any).layer as Leaflet.MultiPolygon;
    const verticies = polygon.getLatLngs()[0];

    if (verticies.length === 4) {
      this.map!.editTools.stopDrawing();

      this.setEditingState(polygon.toGeoJSON());
      this.map!.removeLayer(polygon);

      this.map!.off('editable:drawing:clicked', this.autoComplete); // cleanup
    }
  };

  /* Manage Leaflet state */
  setEditingState = (geoJson: any) => {
    EditableField.clear();
    EditableField.update(this.map!, geoJson);

    const { lat, lng: long } = EditableField.getCenter();

    const editing = { ...this.state.editing };
    merge(editing, { lat, long, geoJson: JSON.stringify(geoJson) });

    this.historyBuffer.push(geoJson);
    this.setState({ editing });
  };

  /* Input event handlers */
  updateName = (event: React.FormEvent<EventTarget>) => {
    const target = event.target as HTMLInputElement;

    const editing = { ...this.state.editing };
    merge(editing, { name: target.value });

    this.setState({ editing, nameError: undefined });
  };

  validate = () => {
    const namePresent = this.state.editing.name !== '';
    const geoJsonPresent = this.state.editing.geoJson !== '';
    return namePresent && geoJsonPresent;
  };

  /* Actions */
  saveMap = () => {
    const { lat, long, zoom } = this.state;

    runMutation(
      UpdateMapMutation,
      { input: { lat, long, zoom } },
      { complete: this.mutationComplete, failed: this.mutationFailed }
    );
  };

  createField = () => {
    runMutation(
      CreateFieldMutation,
      { input: this.state.editing },
      { complete: this.mutationComplete, failed: this.mutationFailed }
    );
  };

  saveField = () => {
    runMutation(
      UpdateFieldMutation,
      { input: this.state.editing },
      { complete: this.mutationComplete, failed: this.mutationFailed }
    );
  };

  deleteField = () => {
    return () => {
      runMutation(
        DeleteFieldMutation,
        { input: { id: this.state.editing.id } },
        { complete: this.deleteComplete }
      );
    };
  };

  openImportModal = () => {
    this.setState({ modalOpen: true });
  };

  closeImportModal = () => {
    this.setState({ modalOpen: false });
  };

  /* Mutation handlers */
  mutationComplete = () => {
    EditableField.clear();
    this.setState({ mode: 'none', submitting: false, editing: newField });
    setTimeout(() => this.setState({ mode: 'view' }), 100);
  };

  mutationFailed = (result: MutationResult) => {
    const userErrors = result.userErrors || [];
    const nameError = userErrors.filter(e => e.field === 'name')[0];

    this.setState({ nameError, submitting: false });
  };

  deleteComplete = () => {
    EditableField.clear();
    this.setState({ mode: 'view', editing: newField });
  };

  /* Rendering */
  render() {
    const { lat, long, zoom, editing, submitting } = this.state;
    const fields = this.props.fields.filter(f => f.id !== editing.id);

    return (
      <FieldsEditorMap
        ref={this.mapRef}
        lat={lat}
        long={long}
        zoom={zoom}
        fields={fields}
        updateMap={this.updateMap}
        editField={this.editField}
      >
        <FieldsEditorInput
          mode={this.state.mode}
          name={this.state.editing.name}
          updateName={this.updateName}
          nameError={this.state.nameError}
        />
        <FieldsEditorControls
          mode={this.state.mode}
          squareFieldCorners={this.squareFieldCorners}
          undoEdit={this.undoEdit}
          redrawField={this.redrawField}
        />
        <FieldsEditorActions
          mode={this.state.mode}
          valid={this.validate()}
          submitting={submitting}
          editMap={this.editMap}
          addField={this.addField}
          saveMap={this.saveMap}
          createField={this.createField}
          saveField={this.saveField}
          deleteField={this.deleteField()}
          importFields={this.openImportModal}
          cancel={this.cancelMode}
        />
        <FieldImport
          open={this.state.modalOpen}
          onClose={this.closeImportModal}
        />
      </FieldsEditorMap>
    );
  }
}

export default FieldsEditor;
