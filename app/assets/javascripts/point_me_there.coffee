class TournamentApp.PointMeThere

  constructor: (@$modal, @map) ->
    @$arrow = $('#arrow')

  setDestination: (destination) ->
    @destination = destination
    @$modal.find('.modal-title').text(@destination.name)

  start: ->
    setInterval(@_getLocation, 500)
    @_show()

  _show: ->
    @$modal.modal('show')

  _getLocation: =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@_calcArrow)
    else
      alert("Geolocation is not supported by this browser.")

  _calcArrow: (location) =>
    lat = location.coords.latitude
    long = location.coords.longitude

    dstLat = @destination.lat
    dstLng = @destination.long

    # for debuging
    @_drawPoint(lat, long, 'You are here.')
    @_drawPoint(dstLat, dstLng, @destination.name)

    bearing = @_getBearing(lat, long, dstLat, dstLng)
    angle = bearing - location.coords.heading
    @_animateArrow(angle)

    distance = @_getDistance(lat, long, dstLat, dstLng)
    @$modal.find('.modal-footer').text("#{distance.toFixed(2)} meters")

  _drawPoint: (lat, lng, title) ->
    latLng = new google.maps.LatLng(lat, lng)

    point = new google.maps.Marker(
      position: latLng,
      map: @map
      title: title
    )

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
    d = R * c * 1000 # Distance in meter
    return d


  _animateArrow: (bearing) ->
    @$arrow.css('-webkit-transform', "rotate(#{bearing}deg)");
    @$arrow.css('-moz-transform', "rotate(#{bearing}deg)");
    @$arrow.css('transform', "rotate(#{bearing}deg)");

window.toRad = (deg) ->
  deg * Math.PI / 180

window.toDeg = (rad) ->
  rad * 180 / Math.PI
