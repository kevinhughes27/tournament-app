class TournamentApp.FieldCreator

  constructor: (@tournmanentLocation, @zoom, @savePath) ->
    google.maps.event.addDomListener(window, 'load', @initializeMap)

  initializeMap: =>
    @map = new google.maps.Map(document.getElementById('map-canvas'), {
      zoom: @zoom,
      center: new google.maps.LatLng(@tournmanentLocation...),
      mapTypeId: google.maps.MapTypeId.SATELLITE
    })

    @initSearchBar()
    @initSaveButton()

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

  initSaveButton: ->
    input = document.getElementById('control-div')
    @map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input)
    google.maps.event.addDomListener input, 'click', @save

  save: =>
    data =
      tournament:
        zoom: @map.zoom
        lat: @map.center.lat()
        long: @map.center.lng()

    $.ajax
      type: 'POST'
      url: @savePath
      data: data
      dataType: 'json'
      success: (response) ->
        TournamentApp.Flash.notice('Fields Updated')
      error: (response) ->
