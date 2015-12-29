class Admin.Sidebar

  constructor: ->

  toggle: ->
    $("body").toggleClass(@_class())

  expand: ->
    $("body").removeClass(@_class())

  collapse: ->
    $('body').addClass(@_class())

  _class: ->
    if @_smallScreen()
      "sidebar-open"
    else
      "sidebar-collapse"

  _smallScreen: ->
    $(window).width() <= 768
