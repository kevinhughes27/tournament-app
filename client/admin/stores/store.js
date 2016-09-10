import {EventEmitter} from 'events';
import _extend from 'lodash/extend';

let Store = _extend({}, EventEmitter.prototype, {
  emitChange() {
    this.emit('change');
  },

  addChangeListener(callback) {
    this.on('change', callback);
  },

  removeChangeListener(callback) {
    this.removeListener('change', callback);
  }
});

module.exports = Store;
