class TournamentApp.TournmanentMap

  constructor: (@tournmanentLocation, @zoom) ->
    window.initializeMap = @initializeMap
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

    @initSearchBar()
    @initCallbacks()

  initSearchBar: ->
    input = document.getElementById('pac-input')
    @map.controls[google.maps.ControlPosition.TOP_LEFT].push(input)

    @searchBox = new google.maps.places.SearchBox(input)

    google.maps.event.addListener @searchBox, 'places_changed', =>
      places = @searchBox.getPlaces()
      bounds = new google.maps.LatLngBounds()

      for place in places
        bounds.extend(place.geometry.location);

      @map.fitBounds(bounds);

  initCallbacks: ->
    google.maps.event.addListener @map, 'center_changed', =>
      $('#tournament_lat').val( @map.center.lat() )
      $('#tournament_long').val( @map.center.lng() )

    google.maps.event.addListener @map, 'zoom_changed', =>
      $('#tournament_zoom').val( @map.zoom )
