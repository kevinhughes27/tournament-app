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

export default (geojson, map, t = 1) => {
  const coordinates = uniqWith(geojson.geometry.coordinates[0], isEqual);

  let points = coordinates.map((p) => project(p, map));

  let newPoints = [];
  let score = Infinity;

  for (let i = 0; i < maxIterations; i++) {
    let motions = points.map(calcMotion);

    for (let j = 0; j < motions.length; j++) {
      points[j] = addPoints(points[j],motions[j]);
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

  points = newPoints.map((p) => unproject(p, map));

  return {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "type": "Polygon",
      "coordinates": [points.map((p) => [p[1], p[0]] )]
    }
  };
}

function project(coord, map) {
  const latLng = new Leaflet.LatLng(coord[1], coord[0]);
  const point = map.latLngToLayerPoint(latLng);
  return [point.x, point.y];
}

function unproject(coord, map) {
  const point = new Leaflet.Point(coord[0], coord[1]);
  const latLng = map.layerPointToLatLng(point);
  return [latLng.lat, latLng.lng];
}

function calcMotion(b, i, array) {
  var a = array[(i - 1 + array.length) % array.length],
      c = array[(i + 1) % array.length],
      p = subtractPoints(a, b),
      q = subtractPoints(c, b),
      scale, dotp;

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

function squareness(points) {
  return points.reduce(function(sum, val, i, array) {
    var dotp = normalizedDotProduct(i, array);

    dotp = filterDotProduct(dotp);
    return sum + 2.0 * Math.min(Math.abs(dotp - 1.0), Math.min(Math.abs(dotp), Math.abs(dotp + 1)));
  }, 0);
}

function normalizedDotProduct(i, points) {
  var a = points[(i - 1 + points.length) % points.length],
      b = points[i],
      c = points[(i + 1) % points.length],
      p = subtractPoints(a, b),
      q = subtractPoints(c, b);

  p = normalizePoint(p, 1.0);
  q = normalizePoint(q, 1.0);

  return p[0] * q[0] + p[1] * q[1];
}

function subtractPoints(a, b) {
  return [a[0] - b[0], a[1] - b[1]];
}

function addPoints(a, b) {
  return [a[0] + b[0], a[1] + b[1]];
}

function normalizePoint(point, scale) {
  var vector = [0, 0];
  var length = Math.sqrt(point[0] * point[0] + point[1] * point[1]);
  if (length !== 0) {
    vector[0] = point[0] / length;
    vector[1] = point[1] / length;
  }

  vector[0] *= scale;
  vector[1] *= scale;

  return vector;
}

function filterDotProduct(dotp) {
  if (lowerThreshold > Math.abs(dotp) || Math.abs(dotp) > upperThreshold) {
    return dotp;
  }

  return 0;
}

// linear interpolation
export function geoVecInterp(a, b, t) {
  return [
      a[0] + (b[0] - a[0]) * t,
      a[1] + (b[1] - a[1]) * t
  ];
}

// http://jsperf.com/id-dist-optimization
function geoVecLength(a, b) {
  var x = a[0] - b[0];
  var y = a[1] - b[1];
  return Math.sqrt((x * x) + (y * y));
}
