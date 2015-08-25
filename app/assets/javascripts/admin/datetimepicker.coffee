Date.parseDate = (input, format) ->
  moment(input,format).toDate()

Date.prototype.dateFormat = ( format ) ->
  moment(this).format(format)

Admin.DatePickerOptions = {
  format:'MM/DD/YYYY h:mm A'
  formatTime:'h:mm A'
  formatDate:'MM/DD/YYYY'
  step: 30
}

$(document).ready ->
  $('.datetimepicker').datetimepicker(Admin.DatePickerOptions)
