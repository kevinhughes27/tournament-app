class TournamentApp.FieldCreator

  constructor: (@tournmanentLocation, @zoom) ->
    window.initializeMap = @initializeMap
    script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=drawing&callback=initializeMap';
    document.body.appendChild(script);

  initializeMap: =>
    @map = new google.maps.Map(document.getElementById('map-canvas'), {
      zoom: @zoom,
      center: new google.maps.LatLng(@tournmanentLocation...),
      mapTypeId: google.maps.MapTypeId.SATELLITE
      disableDefaultUI: true
      zoomControl: true
      zoomControlOptions:
        style: google.maps.ZoomControlStyle.LARGE
        position: google.maps.ControlPosition.RIGHT_BOTTOM
    })

    @initializeDrawingManager()

  initializeDrawingManager: ->
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.MARKER,
      drawingControl: true,
      drawingControlOptions:
        position: google.maps.ControlPosition.TOP_RIGHT,
        drawingModes: [ google.maps.drawing.OverlayType.POLYGON ]

    google.maps.event.addListener @drawingManager, 'polygoncomplete', (shape) =>
      latLngObject = shape.getPath()
      input = prompt("Please enter a name for the field")

    @drawingManager.setMap(@map);
