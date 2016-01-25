class Sidebar

  toggle: ->
    klass = @_class()
    if @_open(klass) then @collapse(klass) else @expand(klass)

  _open: (klass) ->
    !$("body").hasClass(klass)

  expand: (klass) ->
    $("body").removeClass(klass)
    $.removeCookie('sidebar', {path: '/' })

  collapse: (klass) ->
    $('body').addClass(klass)
    $.cookie("sidebar", klass, {path: '/'})

  _class: ->
    if @_smallScreen()
      "sidebar-open"
    else
      "sidebar-collapse"

  _smallScreen: ->
    $(window).width() <= 768

instance = new Sidebar

Admin.Sidebar = ->
  return instance
