$(document).on 'page:change', ->
  $('.js-btn-loading').on 'click', (e) ->
    $(e.target).addClass('is-loading')
