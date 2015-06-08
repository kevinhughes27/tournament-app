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

    @fields = []
    @initializeDrawingManager()


  initializeDrawingManager: ->
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.POLYGON,
      drawingControl: true,
      drawingControlOptions:
        position: google.maps.ControlPosition.TOP_RIGHT,
        drawingModes: [ google.maps.drawing.OverlayType.POLYGON ]

    @drawingManager.setMap(@map)

    google.maps.event.addListener @drawingManager, 'polygoncomplete', @_newField


  _newField: (shape) =>
    latLngPts = shape.getPath().getArray()

    valid = latLngPts.length == 4

    if !valid
      alert("A field must have 4 points")
      shape.setMap(null)
    else
      fieldName = @_promptForFieldName()

      @fields.push(
        name: fieldName
        points: latLngPts
      )

      @_renderFields()


  _promptForFieldName: ->
    fieldName = null
    while !fieldName
      fieldName = prompt("Please enter a name for the field")
    fieldName


  _renderFields: ->
    node = $("#fields > tbody")
    node.find("tr").remove()

    @fields.reverse().forEach (field) ->
      tr = """
      <tr>
        <td>#{field.name}</td>
        <td>#{field.points[0]}</td>
        <td>#{field.points[1]}</td>
        <td>#{field.points[2]}</td>
        <td>#{field.points[3]}</td>
      </tr>
      """
      node.append(tr)
