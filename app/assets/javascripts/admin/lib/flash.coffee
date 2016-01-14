$(document).on 'ready page:change', (event) ->
  return unless $('.js-flash').hasClass('hide')

  _.delay ->
    $node = $('.js-flash-message')
    isError = $node.hasClass('error')
    Flash.display(message, isError) if message = $node.text()

Admin.Flash = Flash =
  error: (message, duration = 2200) ->
    Flash.display message, true, duration

  notice: (message, duration = 2200) ->
    Flash.display message, false, duration

  display: (message, isError, duration = 2200) ->
    clearTimeout(@timeout) if @timeout

    $node = $('.js-flash')
    $node.find('b').text(message)

    # keep the flash centered
    if $('body').hasClass('sidebar-collapse')
      $node.css('left','0')
    else
      $node.css('left','110px') # admin lte sidebar width / 2

    if isError
      $node.addClass('flash-danger')
      $node.removeClass('flash-success')
    else
      $node.addClass('flash-success')
      $node.removeClass('flash-danger')

    $node.removeClass('hide')
    @timeout = setTimeout Flash.hide.bind(@), duration

  _center: ($node) ->

  hide: ->
    $node = $('.js-flash')
    $node.find('b').text('')
    $node.addClass('hide')
