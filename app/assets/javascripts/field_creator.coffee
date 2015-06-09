class TournamentApp.FieldCreator

  constructor: (@tournmanentLocation, @zoom, @fields) ->
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
    @initializeExistingFields()


  initializeDrawingManager: ->
    @drawingManager = new google.maps.drawing.DrawingManager
      drawingMode: google.maps.drawing.OverlayType.POLYGON,
      drawingControl: true,
      drawingControlOptions:
        position: google.maps.ControlPosition.TOP_RIGHT,
        drawingModes: [ google.maps.drawing.OverlayType.POLYGON ]

    @drawingManager.setMap(@map)

    google.maps.event.addListener @drawingManager, 'polygoncomplete', @_newField

    # quit drawing if esc pressed
    google.maps.event.addDomListener document, 'keyup', (e) =>
      code = if e.keyCode then e.keyCode else e.which
      @_cancelled = true
      @drawingManager.setDrawingMode(null) if code == 27


  initializeExistingFields: ->
    for field in @fields
      @_initField(field)
      @_drawField(field)

    @_renderFields()


  _initField: (field) ->
    field.center = new google.maps.LatLng(field.lat, field.long)

    field.points = []
    for pt in JSON.parse(field.polygon)
      field.points.push new google.maps.LatLng(pt.A, pt.F)


  _drawField: (field) ->
    polygon = new google.maps.Polygon(
      paths: field.points,
      fillColor: '#7FC013'
    )

    field.shape = polygon
    polygon.setMap(@map)


  _newField: (shape) =>
    if @_cancelled
      delete @_cancelled
      shape.setMap(null)
      return

    shape.setOptions({fillColor: '#7FC013'})
    latLngPts = shape.getPath().getArray()

    valid = latLngPts.length == 4

    bounds = new google.maps.LatLngBounds()
    bounds.extend(pt) for pt in latLngPts
    center = bounds.getCenter()

    if !valid
      alert("A field must have 4 points")
      shape.setMap(null)
    else
      fieldName = @_promptForFieldName()

      @fields.push(
        name: fieldName
        center: center
        points: latLngPts
        shape: shape
      )

      @_renderFields()


  _promptForFieldName: ->
    fieldName = null
    while !fieldName
      fieldName = prompt("Please enter a name for the field")
    fieldName


  _fieldHoverOn: (event) => @_fieldHover(event, true)
  _fieldHoverOut: (event) => @_fieldHover(event, false)
  _fieldHover: (event, over) =>
    index = $(event.target).parents('tr').data('index')
    field = @fields[index]

    if over
      field.shape.setOptions({fillColor: '#4096EE'})
    else
      field.shape.setOptions({fillColor: '#7FC013'})

  _deleteField: (event) =>
    index = $(event.target).data('index')
    field = @fields.splice(index, 1)[0]
    field.shape.setMap(null)
    @_renderFields()


  _renderFields: ->
    node = $("#fields > tbody")
    node.find("tr").remove()

    @fields.reverse().forEach (field, index) ->
      tr = """
      <tr id="field" data-index="#{index}">
        <td>#{field.name}</td>
        <td>#{field.points[0]}</td>
        <td>#{field.points[1]}</td>
        <td>#{field.points[2]}</td>
        <td>#{field.points[3]}</td>
        <td id="x"><a href="#" data-index="#{index}">x</a></td>

        #{ if field.id then "<input type='hidden' name='fields[][id]' value='#{field.id}'>" else ""}

        <input type="hidden" name="fields[][name]" value="#{field.name}">
        <input type="hidden" name="fields[][lat]" value="#{field.center.lat()}">
        <input type="hidden" name="fields[][long]" value="#{field.center.lng()}">
        <input type="hidden" name="fields[][polygon]" value='#{JSON.stringify(field.points)}'>
      </tr>
      """
      node.append(tr)

    $('tr#field').hover @_fieldHoverOn, @_fieldHoverOut
    $('td#x').click @_deleteField
