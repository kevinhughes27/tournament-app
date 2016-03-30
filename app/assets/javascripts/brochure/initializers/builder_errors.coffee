$(document).ready ->
  $('.builder-card').on 'keyup', '.field_with_errors', (event) ->
    $(event.target).parent().removeClass('field_with_errors')
    $(event.target).parent().parent().find('.error_message').remove()

    # this pushes fake state into the history so that if the
    # user presses back the page reloads proper and uses
    # the back animation
    history.pushState(null, null, null)
