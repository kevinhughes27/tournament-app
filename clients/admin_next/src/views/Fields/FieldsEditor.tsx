import * as React from "react";
import * as Leaflet from "leaflet";
import "leaflet-editable"
import {createFragmentContainer, graphql} from "react-relay";
import { Map, TileLayer } from "react-leaflet";
import { FieldStyle, FieldHoverStyle } from "./FieldStyle";
import Geosuggest, { Suggest } from "react-geosuggest";
import TextField from "@material-ui/core/TextField";
import { FieldNameInput } from "../../assets/jss/styles";
import ActionMenu from "../../components/ActionMenu";
import ActionButton from "../../components/ActionButton";
import EditIcon from "@material-ui/icons/Edit";
import AddIcon from "@material-ui/icons/Add";
import { merge } from "lodash";
import UpdateMapMutation from "../../mutations/UpdateMap";
import UpdateFieldMutation from "../../mutations/UpdateField";
import CreateFieldMutation from "../../mutations/CreateField";
import { showNotice } from "../../components/Notice";

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
  }
}

const newField = {
  name: "",
  lat: 0,
  long: 0,
  geoJson: ""
}

class FieldsEditor extends React.Component<Props, State> {
  mapRef = React.createRef<Map<any>>();
  map?: Leaflet.Map;

  constructor(props: Props) {
    super(props);
    const { lat, long, zoom } = props.map;
    this.state = {lat, long, zoom, mode: "view", editing: newField};
  }

  componentDidMount() {
    this.map = this.mapRef.current!.leafletElement;

    this.map.on("editable:drawing:commit", this.updateField);
    this.map.on("editable:vertex:dragend", this.updateField);
    this.map.on("editable:vertex:rawclick", this.noOp); // prevent vertex delete

    this.drawFields();
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
    const freshField = this.props.fields.find((f) => f.id === field.id);
    this.setState({mode: "editField", editing: freshField!});
  }

  resetEditing = () => {
    this.map!.eachLayer((layer: any) => {
      layer.disableEdit && layer.disableEdit()
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
    const verticies = event.layer.getLatLngs()[0]

    if (verticies.length === 4) {
      event.editTools.commitDrawing(); // auto complete the polygon on the 4th vertex
      event.layer.setStyle(FieldStyle);
      this.map!.off("editable:drawing:clicked", this.autoComplete); // cleanup
    }
  }

  /* Input event handlers */
  placeSelected = (suggest: Suggest) => {
    const location = suggest.location;

    const lat = parseFloat(location.lat);
    const long = parseFloat(location.lng);
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

    return (
      <div>
        {this.renderControls()}
        <Map
          ref={this.mapRef}
          center={[lat, long]}
          zoom={zoom}
          maxZoom={20}
          doubleClickZoom={false}
          onDrag={this.updateMap}
          onZoom={this.updateMap}
          editable={true}
          editOptions={{
            skipMiddleMarkers: true
          }}
        >
          <TileLayer
            url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
            subdomains={["mt0", "mt1", "mt2", "mt3"]}
          />
        </Map>
        {this.renderAction()}
      </div>
    );
  }

  renderControls = () => {
    const { mode } = this.state;

    if (mode === "editMap") {
      return (
        <Geosuggest
          className="leaflet-search"
          inputClassName="leaflet-search-input"
          suggestsClassName="leaflet-search-results"
          minLength={3}
          onSuggestSelect={this.placeSelected}
        />
      );
    } else if (mode === "addField" || mode === "editField") {
      return (
        <TextField
          name="name"
          label="Name"
          margin="normal"
          autoComplete="off"
          fullWidth
          style={FieldNameInput}
          InputLabelProps={{style: {paddingLeft: 10}}}
          value={this.state.editing.name}
          onChange={this.updateName}
        />
      );
    } else {
      return null;
    }
  }

  renderAction = () => {
    const { mode } = this.state;

    if (mode === "view") {
      return this.viewActions();
    } else if (mode === "editMap") {
      return <ActionButton icon="save" onClick={this.saveMap} />;
    } else if (mode === "addField") {
      return <ActionButton icon="save" onClick={this.createField} />;
    } else if (mode === "editField") {
      return <ActionButton icon="save" onClick={this.saveField} />;
    } else {
      return null;
    }
  }

  viewActions = () => {
    const actions = [
      {icon: <EditIcon/>, name: "Edit Map", handler: this.editMap },
      {icon: <AddIcon/>, name: "Add Field", handler: this.addField },
    ];

    return <ActionMenu actions={actions}/>;
  }

  drawFields = () => {
    const { fields } = this.props;

    fields.forEach((field: FieldsEditor_fields[0]) => {
      const json = JSON.parse(field.geoJson);
      const style = () => FieldStyle;
      const layers = Leaflet.geoJson(json, {style: style}).addTo(this.map!);

      layers.eachLayer((layer: any) => {
        layer.on("click", () => this.editField(field, layer));
        layer.on("mouseover", () => layer.setStyle(FieldHoverStyle));
        layer.on("mouseout", () => layer.setStyle(FieldStyle));
      })
    });
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
