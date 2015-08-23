Admin.Flash = Flash =
  error: (message, duration = 2200) ->
    Flash.display message, true, duration

  notice: (message, duration = 2200) ->
    Flash.display message, false, duration

  display: (message, isError, duration = 2200) ->
    clearTimeout(@timeout) if @timeout

    $node = $('.js-alert')
    $node.find('b').text(message)

    # keep the flash centered
    if $('body').hasClass('sidebar-collapse')
      $node.css('left','0')
    else
      $node.css('left','115px') # admin lte sidebar width / 2

    if isError
      $node.addClass('alert-danger')
      $node.removeClass('alert-success')
    else
      $node.addClass('alert-success')
      $node.removeClass('alert-danger')

    $node.css('display','block')
    @timeout = setTimeout Flash.hide.bind(@), duration

  hide: ->
    $node = $('.js-alert')
    $node.find('b').text('')
    $node.css('display', 'none')

$ ->
  $(".alert").not('.js-alert').delay(500).fadeIn "normal", ->
    $(this).delay(1500).fadeOut()
