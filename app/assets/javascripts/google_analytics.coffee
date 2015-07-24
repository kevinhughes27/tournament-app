class @GoogleAnalytics

  @load: ->
    # Google Analytics depends on a global _gaq array. window is the global scope.
    window._gaq = []
    window._gaq.push ["_setAccount", GoogleAnalytics.analyticsId()]

    # Create a script element and insert it in the DOM
    ga = document.createElement("script")
    ga.type = "text/javascript"
    ga.async = true
    ga.src = ((if "https:" is document.location.protocol then "https://ssl" else "http://www")) + ".google-analytics.com/ga.js"
    firstScript = document.getElementsByTagName("script")[0]
    firstScript.parentNode.insertBefore ga, firstScript

    # If Turbolinks is supported, set up a callback to track pageviews on page:change.
    # If it isn't supported, just track the pageview now.
    if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
      document.addEventListener "page:change", (->
        GoogleAnalytics.trackPageview()
      ), true
    else
      GoogleAnalytics.trackPageview()

  @trackPageview: (url) ->
    unless GoogleAnalytics.isLocalRequest()
      if url
        window._gaq.push ["_trackPageview", url]
      else
        window._gaq.push ["_trackPageview"]
      window._gaq.push ["_trackPageLoadTime"]

  @trackEvent: (event) ->
    data = event.currentTarget.getAttribute('track-click')

    try
      fn = new Function("return " + data)
    catch error
      trackClickError("track-click: was unable to make a function with #{data}", target)

    obj = fn.call()

    if !(obj.action? && obj.category?)
      trackClickError("track-click: must have an action and a category, you supplied #{data}", target)

    window._gaq.push ["_trackEvent", obj.category, obj.action]

  @isLocalRequest: ->
    GoogleAnalytics.documentDomainIncludes "local"

  @documentDomainIncludes: (str) ->
    document.domain.indexOf(str) isnt -1

  @analyticsId: ->
    # your google analytics ID(s) here...
    'UA-65432378-1'

GoogleAnalytics.load()

$(document).on 'click', '[track-click]', (event) ->
  GoogleAnalytics.trackEvent(event)
