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

    # animate modal and remove when its done so we can animate multiple times
    $('.modal-content').addClass('animated pulse').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      $(this).removeClass('animated pulse')

    $('.help-block').remove()

    if errors.email
      $('#user_email').parent().addClass('field_with_errors')
      $('#user_email').after("<span class='help-block'>#{errors.email}</span>")

    if errors.password
      $('#user_password').parent().addClass('field_with_errors')
      $('#user_password').after("<span class='help-block'>#{errors.password}</span>")

    $('.field_with_errors').on "keyup", (event) ->
      $(event.target).parent().find('.help-block').remove()
      $(event.target).parent().removeClass('field_with_errors')
