$(document).on 'page:change', ->
  $(".flash").not('.js-flash').delay(500).fadeIn "normal", (ev) ->
    $(this).delay(1500).fadeOut()
