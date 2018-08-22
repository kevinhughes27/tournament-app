/*
 * Based on:
 * https://github.com/stefanocudini/orthogonalize-js/blob/master/orthogonalize.src.js
 * https://github.com/openstreetmap/iD/blob/master/modules/actions/orthogonalize.js
 *
 */

import { map, clone } from "lodash";

const threshold = 12; // degrees within right or straight to alter
const lowerThreshold = Math.cos((90 - threshold) * Math.PI / 180);
const upperThreshold = Math.cos(threshold * Math.PI / 180);
const corner = {i: 0, dotp: 1};
const maxIterations = 1000;
const epsilon = 1e-9;

export default (geojson, t = 1) => {
  const coords = geojson.geometry.coordinates[0];

  let points = map(coords, (v, _k) =>  [ v[1], v[0] ]);
  let originalPoints = clone(points);
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
      console.log(i);
      break;
    }
  }

  points = newPoints;

  // only move the points that actually moved
  for (let i = 0; i < points.length; i++) {
    if (originalPoints[i][0] !== points[i][0] || originalPoints[i][1] !== points[i][1] ) {
      points[i] = geoInterp(originalPoints[i], points[i], t);
    }
  }

  return {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "type": "Polygon",
      "coordinates": [map(points, (p) => [ p[1], p[0] ])]
    }
  };
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

// http://jsperf.com/id-dist-optimization
function geoVecLength(a, b) {
  var x = a[0] - b[0];
  var y = a[1] - b[1];
  return Math.sqrt((x * x) + (y * y));
}

function geoInterp(p1, p2, t) {
  return [p1[0] + (p2[0] - p1[0]) * t,
          p1[1] + (p2[1] - p1[1]) * t];
}
