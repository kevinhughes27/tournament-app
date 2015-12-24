$(document).on 'page:change', ->
  $(".alert").not('.js-alert').delay(500).fadeIn "normal", ->
    $(this).delay(1500).fadeOut()
