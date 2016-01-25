$(document).on 'ready page:change', (event) ->
  return unless $('#flash').hasClass('hide')

  _.delay ->
    $node = $('#flash-message')
    isError = $node.hasClass('error')
    Flash.display(message, isError) if message = $node.text()

Admin.Flash = Flash =
  error: (message, duration = 2200) ->
    Flash.display message, true, duration

  notice: (message, duration = 2200) ->
    Flash.display message, false, duration

  display: (message, isError, duration = 2200) ->
    clearTimeout(@timeout) if @timeout

    $node = $('#flash')
    $node.find('b').text(message)
    if isError then $node.addClass('error') else $node.removeClass('error')
    @_center($node)

    @_animationSpeed($node, 0.5)
    $node.addClass('animated bounceInUp')
    $node.removeClass('hide')
    @timeout = setTimeout Flash.hide.bind(@), duration

  _center: ($node) ->
    width = $('body')[0].clientWidth
    sidebarWidth = if $('body').hasClass('sidebar-collapse') then 50 else 220
    $node.css('left', "#{sidebarWidth}px");
    $node.css('width', "#{width - sidebarWidth}px")

  _animationSpeed: ($node, duration) ->
    $node.css({
      '-webkit-animation-duration': "#{duration}s";
      '-moz-animation-duration': "#{duration}s";
      '-ms-animation-duration': "#{duration}s";
    })

  hide: ->
    $node = $('#flash')
    $node.find('b').text('')
    @_animationSpeed($node, 3)
    $node.addClass('animated slideOutDown')
