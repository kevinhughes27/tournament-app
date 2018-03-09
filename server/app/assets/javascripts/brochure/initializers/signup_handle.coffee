$(document).ready ->

  if name = $('#tournament_name').val()
    $("#tournament_url_container").show()
    handle = toHandle(name)
    setUrl(handle)

  $('#tournament_name').on "keyup", (event) ->
    name = $(event.target).val()

    if name
      $("#tournament_url_container").fadeIn()
    else
      $("#tournament_url_container").fadeOut()

    handle = toHandle(name)
    setUrl(handle)

toHandle = (string) ->
  string = string.toLowerCase()
  string = string.trim().replace(/ /g, "-")
  string

setUrl = (handle) ->
  $("#tournament_url").text("https://#{handle}.ultimate-tournament.io/")
  $("#tournament_handle").val(handle)
