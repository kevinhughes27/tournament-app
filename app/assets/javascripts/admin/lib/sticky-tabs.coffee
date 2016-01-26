class Admin.StickyTabs

  # this class expects the server to render
  # the tabs with the 'active' class already set
  # or else it can jump on the initial render
  constructor: (@key) ->
    @showTabFromHash() if window.location.hash
    window.addEventListener('hashchange', @showTabFromHash, false)
    $('body').on('shown.bs.tab', @updateHash)

  showTabFromHash: ->
    tabHash = window.location.hash
    $("a[href='#{tabHash}']").tab('show')
    _.defer -> window.scrollTo(0, 0)

  updateHash: (e) =>
    tabHash = e.target.hash
    window.location.hash = tabHash
    $.cookie(@key, tabHash)
    window.scrollTo(0, 0)
