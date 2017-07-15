import ConfirmModal from './confirm_modal'
import {createConfirmation} from 'react-confirm'

// create confirm function
const confirm = createConfirmation(ConfirmModal)

// define confirm function easy to call.
module.exports = function (options = {}) {
  // These arguments will be ConfirmModal props
  return confirm({ undefined, ...options })
}
