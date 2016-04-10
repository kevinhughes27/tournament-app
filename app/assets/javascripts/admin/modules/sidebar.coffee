class Sidebar

  toggle: ->
    if @_smallScreen()
      klass = "sidebar-open"
      if @_open(klass) then @close(klass) else @open(klass)
    else
      klass = "sidebar-collapse"
      if @_expanded(klass) then @collapse(klass) else @expand(klass)

  navigate: (event) ->
    $node = if $(event.target).hasClass('sidebar-link')
      $(event.target)
    else
      $(event.target).parents('.sidebar-link')

    return if $node.length == 0
    event.preventDefault()

    @close() if @_smallScreen()
    Turbolinks.visit($node.attr('href'))

  # desktop and tablet
  expand: (klass) ->
    $("body").removeClass(klass)
    $.removeCookie('sidebar', {path: '/' })

  collapse: (klass) ->
    $('body').addClass(klass)
    $.cookie("sidebar", klass, {path: '/'})

  _expanded: (klass) ->
    !$('body').hasClass(klass)

  # mobile
  open: (klass) ->
    $('body').addClass(klass)
    $.cookie("sidebar", klass, {path: '/'})

  close: (klass) ->
    $("body").removeClass(klass)
    $.removeCookie('sidebar', {path: '/' })

  _open: (klass) ->
    $('body').hasClass(klass)

  _smallScreen: ->
    $(window).width() < 767

instance = new Sidebar

Admin.Sidebar = ->
  return instance

$(document).on 'page:change', ->
  $('body').swipe
    swipeRight: -> Admin.Sidebar().open("sidebar-open")
    swipeLeft: -> Admin.Sidebar().close("sidebar-open")
