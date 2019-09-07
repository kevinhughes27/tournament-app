import _find from 'lodash/find';

export default function(teams, name) {
  return _find(teams, t => t.name.toLowerCase() === name.toLowerCase());
}
