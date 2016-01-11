$(document).ready ->

  $('.signupModal').animatedModal
    color: '#3498DB',
    animatedIn:'fadeInUp',
    animatedOut:'bounceOutDown',
    animationDuration: '0.3s'

  $('.signupModal').on "click", ->
    delay 0.5, $('#user_email').focus()
