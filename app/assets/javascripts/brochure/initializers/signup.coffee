$(document).ready ->

  $('form.new_user').on 'submit', (ev) ->
    ev.preventDefault()

    form = ev.target
    data = $(form).serialize()

    $.ajax
      type: form.method
      url: form.action
      data: data
      dataType: 'json'
      success: handleSuccess
      error: handleError

  handleSuccess = ->
    Turbolinks.visit('/setup')

  handleError = (response) ->
    errors = response.responseJSON.errors

    $('.js-btn-loading').removeClass('is-loading')
    $('.js-btn-loading').val('Sign up')

    # animate modal and remove when its done so we can animate multiple times
    $('.modal-content').addClass('animated pulse').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      $(this).removeClass('animated pulse')

    if errors.email
      $('#user_email').parent().addClass('field_with_errors')

    if errors.password
      $('#user_password').parent().addClass('field_with_errors')

    $('.field_with_errors').on "keyup", (event) ->
      $(event.target).parent().removeClass('field_with_errors')
