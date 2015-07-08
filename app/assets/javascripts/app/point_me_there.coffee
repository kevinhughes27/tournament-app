class TournamentApp.PointMeThere

  constructor: (@$modal) ->
    @$arrow = $('#arrow')
    @defaultOrientation = "portrait"
    @defaultOrientation = "landscape" if screen.width > screen.height

  setDestination: (lat, lng, name = 'destination') ->
    @dstLat = lat
    @dstLng = lng
    @dstName = name
    @$modal.find('.title').text(@dstName)

  start: ->
    window.addEventListener('deviceorientation', @_getHeading)
    navigator.geolocation.watchPosition(@_locationUpdate, @_locationUpdateFail)
    @_calcArrow()

  _locationUpdate: (position) =>
    @lat = position.coords.latitude
    @long = position.coords.longitude

  _locationUpdateFail: =>
    alert("Geolocation is not supported by this browser.")

  _getHeading: (event) =>
    heading = event.alpha
    heading = event.webkitCompassHeading if event.webkitCompassHeading
    heading = @_correctForOrientation(heading)

    @_calcArrow(heading)

  _correctForOrientation: (heading) ->
    adjustment  = 0
    adjustment -= 90 if @defaultOrientation == "landscape"

    orientation = @_getBrowserOrientation()
    return unless orientation

    currentOrientation = orientation.split("-")

    if @defaultOrientation != currentOrientation[0]
      adjustment -= 270 if @defaultOrientation == "landscape"
      adjustment -= 90  if @defaultOrientation == "portrait"

    adjustment -= 180 if currentOrientation[1] == "secondary"

    return heading + adjustment

  _getBrowserOrientation: ->
    if screen.orientation && screen.orientation.type
      screen.orientation.type
    else
      screen.orientation || screen.mozOrientation || screen.msOrientation

  _calcArrow: (heading) ->
    bearing = @_getBearing(@lat, @long, @dstLat, @dstLng)
    distance = @_getDistance(@lat, @long, @dstLat, @dstLng)
    angle = heading + bearing

    @_animateArrow(angle)
    @_renderInfo(@lat, @long, bearing, heading, angle, distance)

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

  _animateArrow: (angle) ->
    @$arrow.css('webkit-transform', "rotate(#{angle}deg)")
    @$arrow.css('moz-transform', "rotate(#{angle}deg)")
    @$arrow.css('transform', "rotate(#{angle}deg)")

  _renderInfo: (lat, long, bearing, heading, angle, distance)->
    node = @$modal.find('.bar-footer')
    node.empty()
    node.append("<p>distance: #{@_round(distance)} meters<p>")

  _round: (val) ->
    val ||= 0
    val.toFixed(3)

window.toRad = (deg) ->
  deg * Math.PI / 180

window.toDeg = (rad) ->
  rad * 180 / Math.PI
