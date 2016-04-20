Date.parseDate = (input, format) ->
  moment(input,format).toDate()

Date.prototype.dateFormat = ( format ) ->
  moment(this).format(format)
