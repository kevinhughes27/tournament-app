$(document).on 'page:change', ->
  $('.js-btn-loadable').on 'click', (e) ->
    form = $(e.target).parents('form')
    formHtml5Errors = form.find(':invalid')
    if formHtml5Errors.length == 0
      $(e.target).addClass('is-loading')

$(document).ajaxComplete ->
  $('.js-btn-loadable').on 'click', (e) ->
    $(e.target).addClass('is-loading')
