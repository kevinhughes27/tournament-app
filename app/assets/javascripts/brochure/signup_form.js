$(document).ready(function() {
  $('form.new_user').on('submit', function(ev) {
    ev.preventDefault();

    form = ev.target;
    data = $(form).serialize();

    $.ajax({
      type: form.method,
      url: form.action,
      data: data,
      dataType: 'json',
      success: handleSuccess,
      error: handleError
    });
  });

  var handleSuccess = function() {
    window.location.href = '/setup';
  }

  var handleError = function(response) {
    errors = response.responseJSON.errors;

    // animate modal and remove when its done so we can animate multiple times
    $('.modal-content').addClass('animated pulse').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
      $(this).removeClass('animated pulse');
    });

    $(':submit').removeAttr('disabled');

    $('.help-block').remove();

    if (errors.email) {
      $('#user_email').parent().addClass('field_error');
      $('#user_email').after("<span class='help-block'>" + errors.email + "</span>");
    }

    if (errors.password) {
      $('#user_password').parent().addClass('field_error');
      $('#user_password').after("<span class='help-block'>" + errors.password + "</span>");
    }

    $('.field_error').on("keyup", function(event) {
      $(event.target).parent().find('.help-block').remove();
      $(event.target).parent().removeClass('field_error');
    });
  }
});
