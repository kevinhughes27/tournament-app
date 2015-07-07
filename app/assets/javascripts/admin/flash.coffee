TournamentApp.Flash = Flash =
  error: (message, duration = 3000) ->
    Flash.display message, true, duration

  notice: (message, duration = 3000) ->
    Flash.display message, false, duration

  display: (message, isError, duration = 3000) ->
    clearTimeout(@timeout) if @timeout

    $node = $('.js-flash')
    $node.text(message)
    $node.toggleClass('errors', isError) if isError?
    $node.css('display','block')

    @timeout = setTimeout Flash.hide.bind(@), duration

  hide: ->
    $node = $('.js-flash')
    $node.text('')
    $node.css('display', 'none')

$ ->
  $(".flash").delay(500).fadeIn "normal", ->
    $(this).delay(1500).fadeOut()
