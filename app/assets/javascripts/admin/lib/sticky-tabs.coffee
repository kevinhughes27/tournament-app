class Admin.StickyTabs

  constructor: (@key) ->
    window.addEventListener('hashchange', @showTabFromHash, false)
    $('body').on 'shown.bs.tab', @updateHash
    @showTabFromHash()

  showTabFromHash: ->
    if tabHash = window.location.hash
      $("a[href='#{tabHash}']").tab('show')
    else if tabHash = localStorage.getItem(@key)
      $("a[href='#{tabHash}']").tab('show')

    window.scrollTo(0, 0)

  updateHash: (e) =>
    tabHash = e.target.hash

    window.location.hash = tabHash
    localStorage.setItem(@key, tabHash)

    window.scrollTo(0, 0)
