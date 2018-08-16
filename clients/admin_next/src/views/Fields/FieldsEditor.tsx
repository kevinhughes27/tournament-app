import * as React from "react";
import * as Leaflet from "leaflet";
import {createFragmentContainer, graphql} from "react-relay";
import FieldsEditorMap from "./FieldsEditorMap";
import FieldsEditorControls from "./FieldsEditorControls";
import FieldsEditorActions from "./FieldsEditorActions";
import UpdateMapMutation from "../../mutations/UpdateMap";
import UpdateFieldMutation from "../../mutations/UpdateField";
import CreateFieldMutation from "../../mutations/CreateField";
import { showNotice } from "../../components/Notice";
import { merge } from "lodash";

interface Props {
  map: FieldsEditor_map;
  fields: FieldsEditor_fields;
}

type Mode = "view" | "editMap" | "addField" | "editField";

interface State {
  mode: Mode;
  lat: number;
  long: number;
  zoom: number;
  editing: {
    fieldId?: string;
    name: string;
    lat: number;
    long: number;
    geoJson: string;
  };
}

const newField = {
  name: "",
  lat: 0,
  long: 0,
  geoJson: ""
};

class FieldsEditor extends React.Component<Props, State> {
  mapRef = React.createRef<any>();
  map?: Leaflet.Map;

  constructor(props: Props) {
    super(props);
    const { lat, long, zoom } = props.map;
    this.state = {lat, long, zoom, mode: "view", editing: newField};
  }

  componentDidMount() {
    this.map = this.mapRef.current!.leafletElement;
    this.map!.on("editable:drawing:commit", this.updateField);
    this.map!.on("editable:vertex:dragend", this.updateField);
    this.map!.on("editable:vertex:rawclick", this.noOp); // prevent vertex delete
  }

  /* Mode change handlers */
  editMap = () => {
    const { lat, long, zoom } = this.props.map;
    this.setState({mode: "editMap", lat, long, zoom});
  }

  addField = () => {
    this.map!.editTools.startPolygon();
    this.map!.on("editable:drawing:clicked", this.autoComplete);
    this.setState({mode: "addField", editing: newField});
  }

  editField = (field: FieldsEditor_fields[0], layer: any) => {
    this.resetEditing();
    layer.enableEdit();
    this.setState({mode: "editField", editing: field});
  }

  resetEditing = () => {
    this.map!.eachLayer((layer: any) => {
      if (layer.disableEdit) { layer.disableEdit(); }
    });
  }

  /* Leaflet event handlers */
  updateMap = (ev: Leaflet.LeafletEvent) => {
    const {lat, lng: long} = ev.target.getCenter();
    const zoom = ev.target.getZoom();
    this.setState({lat, long, zoom});
  }

  updateField = (event: any) => {
    const {lat, lng: long} = event.layer.getCenter();
    const geoJson = JSON.stringify(event.layer.toGeoJSON());

    const editing = {...this.state.editing};
    merge(editing, {lat, long, geoJson});

    this.setState({editing});
  }

  noOp = (event: any) => {
    event.cancel();
  }

  autoComplete = (event: any) => {
    const verticies = event.layer.getLatLngs()[0];

    if (verticies.length === 4) {
      event.editTools.commitDrawing(); // auto complete the polygon on the 4th vertex
      this.map!.off("editable:drawing:clicked", this.autoComplete); // cleanup
    }
  }

  /* Input event handlers */
  placeSelected = (lat: number, long: number) => {
    const defaultZoom = 15;
    this.setState({lat, long, zoom: defaultZoom});
  }

  updateName = (event: React.FormEvent<EventTarget>) => {
    const target = event.target as HTMLInputElement;

    const editing = {...this.state.editing};
    merge(editing, {name: target.value});

    this.setState({editing});
  }

  /* Save actions */
  saveMap = async () => {
    const { lat, long, zoom } = this.state;
    this.setState({mode: "view"});

    try {
      const result = await UpdateMapMutation.commit({input: {lat, long, zoom}});
      showNotice(result.message!);
    } catch (e) {
      showNotice(e.message);
    }
  }

  createField = async () => {
    const payload = this.state.editing;
    this.resetEditing();
    this.setState({mode: "view"});

    try {
      const result = await CreateFieldMutation.commit({input: payload});
      showNotice(result.message!);
    } catch (e) {
      showNotice(e.message);
    }
  }

  saveField = async () => {
    const payload = {id: this.state.editing.fieldId!, ...this.state.editing};
    this.resetEditing();
    this.setState({mode: "view"});

    try {
      const result = await UpdateFieldMutation.commit({input: payload});
      showNotice(result.message!);
    } catch (e) {
      showNotice(e.message);
    }
  }

  /* Rendering */
  render() {
    const { lat, long, zoom } = this.state;
    const { fields } = this.props;

    return (
      <div>
        <FieldsEditorControls
          mode={this.state.mode}
          placeSelected={this.placeSelected}
          name={this.state.editing.name}
          updateName={this.updateName}
        />
        <FieldsEditorMap
          ref={this.mapRef}
          lat={lat}
          long={long}
          zoom={zoom}
          fields={fields}
          updateMap={this.updateMap}
          editField={this.editField}
        />
        <FieldsEditorActions
          mode={this.state.mode}
          editMap={this.editMap}
          addField={this.addField}
          saveMap={this.saveMap}
          createField={this.createField}
          saveField={this.saveField}
        />
      </div>
    );
  }
}

export default createFragmentContainer(FieldsEditor, {
  map: graphql`
    fragment FieldsEditor_map on Map {
      lat
      long
      zoom
    }
  `,
  fields: graphql`
    fragment FieldsEditor_fields on Field @relay(plural: true) {
      id
      name
      lat
      long
      geoJson
    }
  `
});
