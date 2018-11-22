/*
 * Based on:
 * https://github.com/stefanocudini/orthogonalize-js/blob/master/orthogonalize.src.js
 * https://github.com/openstreetmap/iD/blob/master/modules/actions/orthogonalize.js
 *
 */

import * as Leaflet from "leaflet";
import { clone, uniqWith, isEqual } from "lodash";

const threshold = 12; // degrees within right or straight to alter
const lowerThreshold = Math.cos((90 - threshold) * Math.PI / 180);
const upperThreshold = Math.cos(threshold * Math.PI / 180);
const corner = {i: 0, dotp: 1};
const maxIterations = 1000;
const epsilon = 1e-9;

interface GeoJson {
  geometry: {
    coordinates: Coordinate[][]
  };
}

type Coordinate = number[];

export default (geojson: GeoJson, map: Leaflet.Map) => {
  const coordinates = uniqWith(geojson.geometry.coordinates[0], isEqual);

  const points = coordinates.map((p) => project(p, map));

  let newPoints = clone(points);
  let score = Infinity;

  for (let i = 0; i < maxIterations; i++) {
    const motions = points.map(calcMotion);

    for (let j = 0; j < motions.length; j++) {
      points[j] = addPoints(points[j], motions[j]);
    }

    const newScore = squareness(points);

    if (newScore < score) {
      newPoints = clone(points);
      score = newScore;
    }

    if (score < epsilon) {
      break;
    }
  }

  const newCoordinates = newPoints.map((p) => unproject(p, map));

  return {
    type: "Feature",
    properties: {},
    geometry: {
      type: "Polygon",
      coordinates: [newCoordinates]
    }
  };
};

function project(coord: Coordinate, map: Leaflet.Map) {
  const latLng = new Leaflet.LatLng(coord[1], coord[0]);
  const point = map.latLngToLayerPoint(latLng);
  return [point.x, point.y];
}

function unproject(coord: Coordinate, map: Leaflet.Map) {
  const point = new Leaflet.Point(coord[0], coord[1]);
  const latLng = map.layerPointToLatLng(point);
  return [latLng.lng, latLng.lat];
}

function calcMotion(b: Coordinate, i: number, array: Coordinate[]) {
  const a = array[(i - 1 + array.length) % array.length];
  const c = array[(i + 1) % array.length];
  let p = subtractPoints(a, b);
  let q = subtractPoints(c, b);
  let scale;
  let dotp;

  scale = 2 * Math.min(geoVecLength(p, [0, 0]), geoVecLength(q, [0, 0]));
  p = normalizePoint(p, 1.0);
  q = normalizePoint(q, 1.0);

  dotp = filterDotProduct(p[0] * q[0] + p[1] * q[1]);

  // nasty hack to deal with almost-straight segments (angle is closer to 180 than to 90/270).
  if (array.length > 3) {
    if (dotp < -0.707106781186547) {
      dotp += 1.0;
    }
  } else if (dotp && Math.abs(dotp) < corner.dotp) {
    corner.i = i;
    corner.dotp = Math.abs(dotp);
  }

  return normalizePoint(addPoints(p, q), 0.1 * dotp * scale);
}

function squareness(points: Coordinate[]) {
  return points.reduce((sum, _, i, array) => {
    let dotp = normalizedDotProduct(i, array);

    dotp = filterDotProduct(dotp);
    return sum + 2.0 * Math.min(Math.abs(dotp - 1.0), Math.min(Math.abs(dotp), Math.abs(dotp + 1)));
  }, 0);
}

function normalizedDotProduct(i: number, points: Coordinate[]) {
  const a = points[(i - 1 + points.length) % points.length];
  const b = points[i];
  const c = points[(i + 1) % points.length];
  let p = subtractPoints(a, b);
  let q = subtractPoints(c, b);

  p = normalizePoint(p, 1.0);
  q = normalizePoint(q, 1.0);

  return p[0] * q[0] + p[1] * q[1];
}

function subtractPoints(a: Coordinate, b: Coordinate) {
  return [a[0] - b[0], a[1] - b[1]];
}

function addPoints(a: Coordinate, b: Coordinate) {
  return [a[0] + b[0], a[1] + b[1]];
}

function normalizePoint(point: Coordinate, scale: number) {
  const vector = [0, 0];
  const length = Math.sqrt(point[0] * point[0] + point[1] * point[1]);

  if (length !== 0) {
    vector[0] = point[0] / length;
    vector[1] = point[1] / length;
  }

  vector[0] *= scale;
  vector[1] *= scale;

  return vector;
}

function filterDotProduct(dotp: number) {
  if (lowerThreshold > Math.abs(dotp) || Math.abs(dotp) > upperThreshold) {
    return dotp;
  }

  return 0;
}

// http://jsperf.com/id-dist-optimization
function geoVecLength(a: Coordinate, b: Coordinate) {
  const x = a[0] - b[0];
  const y = a[1] - b[1];
  return Math.sqrt((x * x) + (y * y));
}
