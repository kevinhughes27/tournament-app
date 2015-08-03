describe 'MainScreen', ->
  app = null
  fields = [{name: 'UPI1'}]
  teams = [{name: 'Swift'}]
  games = []

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
