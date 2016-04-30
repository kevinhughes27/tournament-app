Turbolinks.ProgressBar.start = ->
  Turbolinks.controller.adapter.progressBar.setValue(0)
  Turbolinks.controller.adapter.progressBar.show()

Turbolinks.ProgressBar.done = ->
  Turbolinks.controller.adapter.progressBar.setValue(100)
  Turbolinks.controller.adapter.progressBar.hide()

Turbolinks.replace = (html) ->
  Turbolinks.clearCache()
  document.documentElement.innerHTML = html
  Turbolinks.dispatch("turbolinks:load")
