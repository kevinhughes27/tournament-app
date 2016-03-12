$(document).ready ->
  $('#tournament_name').on "keyup", (event) ->
    handle = $(event.target).val()

    if handle
      $("#tournament_url_container").fadeIn()
    else
      $("#tournament_url_container").fadeOut()

    handle = handle.toLowerCase()
    handle = handle.replace(/ /g, "-").trim()

    $("#tournament_url").text("https://#{handle}.ultimate-tournament.io/")
    $("#tournament_handle").val(handle)
