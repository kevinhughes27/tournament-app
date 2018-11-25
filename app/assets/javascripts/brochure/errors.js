$(document).ready(function() {
  $('.signup-card').on('keyup', function(event) {
    $(event.target).parent().parent().find('.error_message').remove();
     // this pushes fake state into the history so that if the
    // user presses back the page reloads proper and uses
    // the back animation
    history.pushState(null, null, null);
  });
});
