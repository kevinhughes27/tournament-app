class Admin.PlacesSearch

  constructor: (@searchCallback)->
    @_injectGoogleAPI()

  _injectGoogleAPI: ->
    if window.googleAPIsLoaded
      googleAPIsLoaded()
      return

    window.googleAPIsLoaded = @googleAPIsLoaded
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places&callback=googleAPIsLoaded'
    document.body.appendChild(script)

  googleAPIsLoaded: =>
    input = document.getElementById('placesSearch')

    @searchBox = new google.maps.places.SearchBox(input)
    @searchBox.addListener('places_changed', @placesChanged)

    # hack since otherwise the click events don't work but only in admin ...
    $(document.body).on 'click', '.pac-container', (ev) => @_fixClickEvent(ev, input)

  placesChanged: =>
    places = @searchBox.getPlaces()
    place = places[0]
    @searchCallback(place)

  _fixClickEvent: (ev, input) ->
    $node = $(ev.target)
    $node = $node.closest('.pac-item') unless $node.hasClass('pac-item')
    input.value = $node.children()[1].innerText + " " + $node.children()[2].innerText
    input.blur()
