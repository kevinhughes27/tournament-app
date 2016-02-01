class Admin.TreeMenu

  constructor: (node) ->
    @$node = $(node)
    @$treeNode = @$node.children('.treeview-menu')
    @$parentNode = @$node.parents('ul.sidebar-menu')
    @animationSpeed = 500

    @$node.on 'click', @toggle

  toggle: (e) =>
    if @$treeNode.is(':visible')
      @closeMenu()
    else
      @closeOtherMenus()
      @openMenu()

  openMenu: ->
    @$treeNode.slideDown @animationSpeed, =>
      @$treeNode.addClass('menu-open')
      @$parentNode.find('li.active').removeClass('active')
      @$node.addClass('active')

  closeMenu: ->
    @$treeNode.slideUp @animationSpeed, => @$treeNode.removeClass('menu-open')
    @$node.removeClass('active')

  closeOtherMenus: ->
    ul = @$parentNode.find('ul:visible').slideUp(@animationSpeed)
    ul.removeClass('menu-open')
