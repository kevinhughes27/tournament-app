class TournamentApp.FieldCreator

  constructor: (@tournmanentLocation, @zoom) ->
    google.maps.event.addDomListener(window, 'load', @initializeMap)

  initializeMap: =>
    @map = new google.maps.Map(document.getElementById('map-canvas'), {
      zoom: @zoom,
      center: new google.maps.LatLng(@tournmanentLocation...),
      mapTypeId: google.maps.MapTypeId.SATELLITE
    })

    @initSearchBar()

  initSearchBar: =>
    input = document.getElementById('pac-input')
    @map.controls[google.maps.ControlPosition.TOP_LEFT].push(input)

    @searchBox = new google.maps.places.SearchBox(input)

    google.maps.event.addListener @searchBox, 'places_changed', =>
      places = @searchBox.getPlaces()
      bounds = new google.maps.LatLngBounds()

      for place in places
        bounds.extend(place.geometry.location);

      @map.fitBounds(bounds);

  drawRectangles: =>
    # rectangle = new google.maps.Rectangle({
    #   strokeColor: '#FF0000',
    #   strokeOpacity: 0.8,
    #   strokeWeight: 2,
    #   fillColor: '#FF0000',
    #   fillOpacity: 0.35,
    #   map: @map,
    #   bounds: new google.maps.LatLngBounds(
    #     new google.maps.LatLng(33.671068, -116.25128),
    #     new google.maps.LatLng(33.685282, -116.233942))
    # });

  save: ->
    @map.zoom
    @map.center
