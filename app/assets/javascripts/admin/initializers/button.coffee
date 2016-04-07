$(document).on 'page:change', ->
  $('.js-btn-loadable').on 'click', (e) ->
    form = $(e.target).parents('form')
    if _.isEmpty(form.find(':invalid'))
      $(e.target).addClass('is-loading')

$(document).ajaxComplete ->
  $('.js-btn-loadable').on 'click', (e) ->
    $(e.target).addClass('is-loading')
