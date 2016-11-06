import FieldsIndex from './components/fields_index'
import DivisionsIndex from './components/divisions_index'
import Division from './components/division'
import TeamsIndex from './components/teams_index'
import GamesIndex from './components/games_index'
import ReportsIndex from './components/reports_index'

import ReactOnRails from 'react-on-rails'

ReactOnRails.register({
  FieldsIndex,
  DivisionsIndex,
  Division,
  TeamsIndex,
  GamesIndex,
  ReportsIndex
})

// non-component modules
import FieldEditor from './modules/field_editor'
import MapForm from './modules/map_form'

window.Admin = {}
window.Admin.FieldEditor = FieldEditor
window.Admin.MapForm = MapForm
