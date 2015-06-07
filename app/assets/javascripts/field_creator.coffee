class TournamentApp.FieldCreator

  constructor: (@tournmanentLocation, @zoom) ->
    window.initializeMap = @initializeMap
    console.log "Got here"
    script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&signed_in=true&libraries=places&callback=initializeMap';
    document.body.appendChild(script);

  initializeMap: =>
    @map = new google.maps.Map(document.getElementById('map-canvas'), {
      zoom: @zoom,
      center: new google.maps.LatLng(@tournmanentLocation...),
      mapTypeId: google.maps.MapTypeId.SATELLITE
    })

    #@initializeDrawing()
###
  initializeDrawing: ->
    google.maps.event.addListener(drawingManager, 'polylinecomplete', function(polyline) {
         @shape = polyline;
         @latLngObject = shape.getPath();
         @input = prompt("Please enter a name for the field");
         if(input !== undefined) {
           console.log input
         }
     });
    drawingManager.setMap(map);

###