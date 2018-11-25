$(document).ready(function() {
  $('.signupModal').animatedModal({
    color: '#3498DB',
    animatedIn:'fadeInUp',
    animatedOut:'bounceOutDown',
    animationDuration: '0.3s'
  });

  $('.signupModal').on("click", function() {
    setTimeout(function() {
      $('#user_email').focus();
    }, 400);
  });
});
