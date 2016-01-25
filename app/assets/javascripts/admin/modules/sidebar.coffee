class Sidebar

  toggle: ->
    klass = @_class()
    if @_open(klass) then @collapse(klass) else @expand(klass)

  _open: (klass) ->
    !$("body").hasClass(klass)

  expand: (klass) ->
    $("body").removeClass(klass)
    $.removeCookie('sidebar', {path: '/' })
    delay 300, ->
      $('.user-panel').find('.info').fadeIn()
      $('.user-panel').find('.fa-chevron-up').fadeIn()

  collapse: (klass) ->
    $('body').addClass(klass)
    $('.user-panel').find('.info').hide()
    $('.user-panel').find('.fa-chevron-up').hide()
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
