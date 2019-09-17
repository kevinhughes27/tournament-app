import * as React from 'react';
import { divIcon } from 'leaflet';
import { Marker } from 'react-leaflet';

const MapLabel = ({ field }) => {
  const icon = divIcon({
    className: 'map-label',
    html: `<span>${field.name}</span>`
  });

  return (
    <Marker
      key={field.id}
      position={{ lat: field.lat, lng: field.long }}
      icon={icon}
    />
  );
}

export default MapLabel;
