var ConfirmModal = require ('./confirm_modal'),
    createConfirmation = require('react-confirm').createConfirmation;

// create confirm function
const confirm = createConfirmation(ConfirmModal);

// define confirm function easy to call.
export default function(options = {}) {
  // These arguments will be ConfirmModal props
  return confirm({ null, ...options });
}
