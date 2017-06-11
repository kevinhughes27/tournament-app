import FieldsIndex from './components/FieldsIndex'
import DivisionsIndex from './components/DivisionsIndex'
import Division from './components/Division'
import TeamsIndex from './components/TeamsIndex'
import GamesIndex from './components/GamesIndex'
import ReportsIndex from './components/ReportsIndex'
import ScheduleEditor from './components/ScheduleEditor'

import ReactOnRails from 'react-on-rails'

ReactOnRails.register({
  FieldsIndex,
  DivisionsIndex,
  Division,
  TeamsIndex,
  GamesIndex,
  ReportsIndex,
  ScheduleEditor
})

// non-component modules
import FieldEditor from './modules/FieldEditor'
import MapForm from './modules/MapForm'

window.Admin = window.Admin || {}
window.Admin.FieldEditor = FieldEditor
window.Admin.MapForm = MapForm
