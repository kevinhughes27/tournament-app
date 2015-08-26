context = {}

reset = (nodes) ->
  if nodes
    Twine.bind(node) for node in nodes
  else
    Twine.reset(context).bind()

  Twine.refreshImmediately()
  return

document.addEventListener 'page:change', -> reset()

document.addEventListener 'page:before-unload', (nodes) ->
  Twine.unbind(node) for node in nodes
  return

document.addEventListener 'page:after-remove', (node) ->
    Twine.unbind(node)
    return

$(document).ajaxComplete ->
  Twine.refresh()
