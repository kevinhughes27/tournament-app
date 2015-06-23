class TournamentApp.PointMeThere

  constructor: (@$modal) ->
    @$arrow = $('#arrow')

  setDestination: (lat, lng, name = 'destination') ->
    @dstLat = lat
    @dstLng = lng
    @dstName = name
    @$modal.find('.modal-title').text(@dstName)

  start: ->
    setInterval(@_getLocation, 500)
    window.addEventListener('deviceorientation', @_calcArrow)
    @_calcArrow()
    @show()

  show: ->
    @$modal.modal('show')

  _getLocation: =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (location) =>
        @lat = location.coords.latitude
        @long = location.coords.longitude
    else
      alert("Geolocation is not supported by this browser.")

  _calcArrow: (event) =>
    bearing = @_getBearing(@lat, @long, @dstLat, @dstLng)
    heading = event.alpha if event
    angle = heading + bearing
    @_animateArrow(angle)

    distance = @_getDistance(@lat, @long, @dstLat, @dstLng)

    @$modal.find('.modal-footer').empty()
    @$modal.find('.modal-footer').append("<p>distance: #{distance.toFixed(2)} meters<p>")

  _getBearing: (lat, lng, dstLat, dstLng) =>
    dLng = toRad(dstLng-lng)
    lat = toRad(lat)
    dstLat = toRad(dstLat)
    y = Math.sin(dLng) * Math.cos(dstLat)
    x = Math.cos(lat)*Math.sin(dstLat) - Math.sin(lat)*Math.cos(dstLat)*Math.cos(dLng)
    rad = Math.atan2(y, x)
    brng = toDeg(rad)
    return (brng + 360) % 360

  _getDistance: (lat, lng, dstLat, dstLng) ->
    R = 6371 # Radius of the earth in km
    dLat = toRad(dstLat - lat)
    dLng = toRad(dstLng - lng)

    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(toRad(lat)) * Math.cos(toRad(dstLat)) *
        Math.sin(dLng/2) * Math.sin(dLng/2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = R * c * 1000 # Distance in meters
    return d

  _animateArrow: (bearing) ->
    @$arrow.css('-webkit-transform', "rotate(#{bearing}deg)");
    @$arrow.css('-moz-transform', "rotate(#{bearing}deg)");
    @$arrow.css('transform', "rotate(#{bearing}deg)");

window.toRad = (deg) ->
  deg * Math.PI / 180

window.toDeg = (rad) ->
  rad * 180 / Math.PI
