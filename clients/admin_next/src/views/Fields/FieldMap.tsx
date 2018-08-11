import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";
import { Map, TileLayer, GeoJSON } from "react-leaflet";
import { LeafletEvent } from "leaflet";
import { FieldStyle, FieldHoverStyle } from "./FieldStyle";
import ActionMenu from "../../components/ActionMenu";
import ActionButton from "../../components/ActionButton";
import EditIcon from "@material-ui/icons/Edit";
import AddIcon from "@material-ui/icons/Add";
import UpdateMapMutation from "../../mutations/UpdateMap";
import { showNotice } from "../../components/Notice";

interface Props extends RouteComponentProps<any> {
  map: FieldMap_map;
  fields: FieldMap_fields;
}

type Mode = "view" | "editMap";

interface State {
  mode: Mode;
  lat: number;
  long: number;
  zoom: number;
  hover?: string;
}

class FieldMap extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    const { lat, long, zoom } = props.map;
    this.state = {mode: "view", lat, long, zoom};
  }

  openFieldNew = () => {
    this.props.history.push("/fields/new");
  }

  editMap = () => {
    const { lat, long, zoom } = this.props.map;
    this.setState({ mode: "editMap", lat, long, zoom});
  }

  updateMap = (ev: LeafletEvent) => {
    const {lat, lng: long} = ev.target.getCenter();
    const zoom = ev.target.getZoom();
    this.setState({lat, long, zoom});
  }

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

  render() {
    const { lat, long, zoom } = this.state;
    const { fields } = this.props;

    return (
      <div>
        <Map
          center={[lat, long]}
          zoom={zoom}
          maxZoom={20}
          onDrag={this.updateMap}
          onZoom={this.updateMap}
        >
          <TileLayer
            url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
            subdomains={["mt0", "mt1", "mt2", "mt3"]}
          />
          {fields.map(this.renderField)}
        </Map>
        {this.renderAction()}
      </div>
    );
  }

  renderAction = () => {
    if (this.state.mode === "view") {
      const actions = [
        {icon: <EditIcon/>, name: "Edit Map", handler: this.editMap },
        {icon: <AddIcon/>, name: "Add Field", handler: this.openFieldNew },
      ];

      return <ActionMenu actions={actions}/>;
    } else {
      return <ActionButton icon="save" onClick={this.saveMap} />;
    }
  }

  renderField = (field: FieldMap_fields[0]) => (
    <GeoJSON
      key={field.id}
      data={JSON.parse(field.geoJson)}
      style={this.fieldStyle(field.id)}
      onMouseover={() => this.setState({hover: field.id})}
      onMouseout={() => this.setState({hover: undefined})}
      onClick={() => this.handleClick(field.id)}
    />
  )

  handleClick = (fieldId: string) => {
    this.props.history.push(`/fields/${fieldId}`);
  }

  fieldStyle = (fieldId: string) => {
    if (this.state.hover === fieldId) {
      return FieldHoverStyle;
    } else {
      return FieldStyle;
    }
  }
}

export default createFragmentContainer(withRouter(FieldMap), {
  map: graphql`
    fragment FieldMap_map on Map {
      lat
      long
      zoom
    }
  `,
  fields: graphql`
    fragment FieldMap_fields on Field @relay(plural: true) {
      id
      name
      lat
      long
      geoJson
    }
  `
});
