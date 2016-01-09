describe 'MainScreen', ->
  app = null
  fields = [{name: 'UPI1', id: 1}, {name: 'UPI2', id: 2}, {name: 'UPI3', id: 3}]
  teams = [{name: 'Swift', id: 1}, {name: 'Goose', id: 2}]
  games = [
    { home_id: 1, away_id: 2, field_id: 1, start_time: moment.utc() },
    { home_id: 1, away_id: 2, field_id: 2, start_time: moment.utc().subtract(3, 'hours') },
    { home_id: 1, away_id: 2, field_id: 3, start_time: moment.utc().add(3, 'hours') },
  ]

  beforeEach ->
    app = new App.MainScreen(
      [45.2466442,-75.6149635],
      17,
      fields,
      teams,
      games,
      80,
      "/somepath"
    )
    spyOn(Twine, 'refresh')

  it "showFieldSelect hides other actions", ->
    app.drawerOpen = true
    spyOn(app, 'finishPointToField')

    app.showFieldSelect()

    expect(app.fieldSearchOpen).toBe(true)
    expect(app.teamSearchOpen).toBe(false)
    expect(app.drawerOpen).toBe(false)
    expect(app.finishPointToField).toHaveBeenCalled()
    expect(Twine.refresh).toHaveBeenCalled()

  it "showTeamSelect hides other actions", ->
    app.drawerOpen = true
    spyOn(app, 'finishPointToField')

    app.showTeamSelect()

    expect(app.teamSearchOpen).toBe(true)
    expect(app.fieldSearchOpen).toBe(false)
    expect(app.drawerOpen).toBe(false)
    expect(app.finishPointToField).toHaveBeenCalled()
    expect(Twine.refresh).toHaveBeenCalled()

  it "searchBlur hides all search bars", ->
    app.teamSearchOpen = true
    app.fieldSearchOpen = true

    app.searchBlur()

    expect(app.teamSearchOpen).toBe(false)
    expect(app.fieldSearchOpen).toBe(false)
    expect(Twine.refresh).toHaveBeenCalled()

  it "fieldSelected returns if event is keyup is not enter", ->
    event = {type: 'keyup', keyCode: 14} # enter is 13
    val = app.fieldSelected(event)
    expect(val).toBe(undefined)

  it "fieldSelected returns if event is change and values is empty", ->
    node = document.createElement("input")
    node.setAttribute("value", "")
    event = {type: 'change', target: node}

    val = app.fieldSelected(event)

    expect(val).toBe(undefined)

  it "fieldSelected returns if no field found", ->
    node = document.createElement("input")
    node.setAttribute("value", "Not a field")
    event = {type: 'change', target: node}
    spyOn(app, 'pointToField')

    app.fieldSelected(event)

    expect(app.pointToField).not.toHaveBeenCalled()

  it "fieldSelected points to field if field found", ->
    node = document.createElement("input")
    node.setAttribute("value", "UPI1")
    event = {type: 'change', target: node}
    spyOn(app, 'pointToField')

    app.fieldSelected(event)

    field = app.pointToField.calls.mostRecent().args[0]
    expect(field.name).toEqual('UPI1')
    expect(app.findText).toEqual('UPI1')

  it "fieldSelected hides field search", ->
    app.fieldSearchOpen = true

    app.fieldSelected(event)

    expect(app.fieldSearchOpen).toBe(false)
    expect(Twine.refresh).toHaveBeenCalled()

  it "teamSelected finds the next game for the team", ->
    node = document.createElement("input")
    node.setAttribute("value", "Swift")
    event = {type: 'change', target: node}
    spyOn(app, 'pointToField')

    app.teamSelected(event)

    field = app.pointToField.calls.mostRecent().args[0]
    expect(field.name).toEqual('UPI1')

    # advance time to the next game
    spyOn(app, '_currentTime').and.returnValue( moment.utc().add(2, 'hours') )

    app.teamSelected(event)

    field = app.pointToField.calls.mostRecent().args[0]
    expect(field.name).toEqual('UPI3')

  it "teamSelected alerts if no upcoming games", ->
    node = document.createElement("input")
    node.setAttribute("value", "Swift")
    event = {type: 'change', target: node}
    spyOn(app, '_currentTime').and.returnValue( moment.utc().add(2, 'days') )
    spyOn(window, 'alert')

    app.teamSelected(event)

    expect(window.alert).toHaveBeenCalledWith("No Upcoming games for Swift")

  it "pointToField adds markers and starts pointMeThere", ->
    app.map = jasmine.createSpyObj('map', ['clearMarkers', 'addMarker'])
    spyOn(app.pointMeThere, 'setDestination')
    spyOn(app.pointMeThere, 'start')

    app.pointToField({lat: 45, long: -72, name: 'UPI1'})

    expect(app.map.clearMarkers).toHaveBeenCalled()
    expect(app.map.addMarker).toHaveBeenCalledWith(45, -72)

    expect(app.pointMeThere.setDestination).toHaveBeenCalledWith(45, -72, 'UPI1')
    expect(app.pointMeThere.start).toHaveBeenCalled()

  it "pointToField callback only alerts about distance once", ->
    event = {distance: 2000}
    spyOn(window, 'alert')

    app._pointToFieldCallback(event)
    app._pointToFieldCallback(event)
    app._pointToFieldCallback(event)

    expect(window.alert.calls.count()).toEqual(1)

  it "pointToField callback drawsPointer", ->
    app.map = jasmine.createSpyObj('map', ['drawPointer'])
    event = {distance: 500, lat: 45, long: -72, heading: 90}

    app._pointToFieldCallback(event)

    expect(app.map.drawPointer).toHaveBeenCalledWith(45, -72, 90)

  it "finishPointToField clears map", ->
    app.findingField = true
    app.map = jasmine.createSpyObj('map', ['clearMarkers', 'clearPointer', 'centerMap'])

    app.finishPointToField()

    expect(app.findingField).toBe(false)
    expect(app.map.clearMarkers).toHaveBeenCalled()
    expect(app.map.clearPointer).toHaveBeenCalled()
    expect(app.map.centerMap).toHaveBeenCalled()
    expect(Twine.refresh).toHaveBeenCalled()
