$(document).ready ->
  $('.js-btn-loading').on 'click', (e) ->
    $(e.target).addClass('is-loading')
    width = e.target.clientWidth
    e.target.value = ''
    $(e.target).css('width', width)
