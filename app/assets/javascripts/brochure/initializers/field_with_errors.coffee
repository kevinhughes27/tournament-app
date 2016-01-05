$(document).ready ->
  $('.field_with_errors > input').on "keyup", (event) ->
    $(event.target).parent().removeClass('field_with_errors')
