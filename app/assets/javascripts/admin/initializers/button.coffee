$(document).on 'page:change', ->
  $('.js-btn-loadable').on 'click', (e) ->
    $(e.target).addClass('is-loading')
