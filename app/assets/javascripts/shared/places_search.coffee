window.UT ||= {}

class UT.PlacesSearch

  constructor: (@searchCallback)->
    @_injectGoogleAPI()

  _injectGoogleAPI: ->
    return if window.googleAPIsLoaded

    window.googleAPIsLoaded = @googleAPIsLoaded
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places&callback=googleAPIsLoaded'
    document.body.appendChild(script)

  googleAPIsLoaded: =>
    input = document.getElementById('placesSearch')
    @searchBox = new google.maps.places.SearchBox(input)
    @searchBox.addListener('places_changed', @placesChanged)

  placesChanged: =>
    places = @searchBox.getPlaces()
    place = places[0]
    @searchCallback(place)
