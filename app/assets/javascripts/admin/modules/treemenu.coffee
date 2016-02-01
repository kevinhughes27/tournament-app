class Admin.TreeMenu

  constructor: (@name, node) ->
    @$node = $(node)
    @$treeNode = @$node.children('.treeview-menu')
    @$parentNode = @$node.parents('ul.sidebar-menu')
    @animationSpeed = 350

    @$node.children('a').on 'click', @toggle

  toggle: (e) =>
    if @$treeNode.is(':visible')
      @closeMenu()
    else
      @closeOtherMenus()
      @openMenu()

  openMenu: ->
    $.cookie('sidebar-menu', @name, {path: '/'})
    @$treeNode.slideDown @animationSpeed, =>
      @$parentNode.find('li.active').removeClass('active')
      @$node.addClass('active')

  closeMenu: ->
    $.removeCookie('sidebar-menu', {path: '/' })
    @$treeNode.slideUp @animationSpeed, =>
      @$node.removeClass('active')

  closeOtherMenus: ->
    @$parentNode.find('ul:visible').slideUp(@animationSpeed)
