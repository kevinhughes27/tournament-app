context = {}

$(document).on 'turbolinks:load', ->
  Twine.reset(context).bind().refresh()
  return

$(document).ajaxComplete ->
  Twine.refresh()
