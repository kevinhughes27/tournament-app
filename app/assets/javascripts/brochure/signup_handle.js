$(document).ready(function() {
  var name = $('#tournament_name').val();
  var handle = null;

  if (name) {
    $("#tournament_url_container").show();
    handle = toHandle(name);
    setUrl(handle);
  }

  $('#tournament_name').on("keyup", function(event) {
    name = $(event.target).val();

    if (name) {
      $("#tournament_url_container").fadeIn();
    } else {
      $("#tournament_url_container").fadeOut();
    }

    handle = toHandle(name);
    setUrl(handle);
  });
});

var toHandle = function(string) {
  string = string.toLowerCase();
  string = string.trim().replace(/ /g, "-");
  return string;
}

var setUrl = function(handle) {
  $("#tournament_url").text("https://" + handle + ".ultimate-tournament.io/");
  $("#tournament_handle").val(handle);
}
