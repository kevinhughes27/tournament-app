Turbolinks.replace = (html) ->
  Turbolinks.clearCache()
  document.documentElement.innerHTML = html
  Turbolinks.dispatch("turbolinks:load")
