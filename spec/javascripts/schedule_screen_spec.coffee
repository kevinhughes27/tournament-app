describe 'ScheduleScreen', ->
  app = null
  screen = null

  beforeEach ->
    app = {
      fields: [{name: 'UPI1'}, {name: 'UPI2'}, {name: 'UPI3'}]
      pointToField: (field) -> {}
    }

    screen = new TournamentApp.ScheduleScreen(app)
    spyOn(Twine, 'refresh')

  it "show sets active and calls Twine.refresh", ->
    expect(screen.active).toBe(false)

    screen.show()

    expect(screen.active).toBe(true)
    expect(Twine.refresh).toHaveBeenCalled()

  it "show sets location.hash", ->
    screen.show()
    expect(window.location.hash).toEqual("#schedule")

  it "close resets location.hash", ->
    screen.close()
    expect(window.location.hash).toEqual("")

  it "close sets active to false and calls Twine.refresh", ->
    screen.active = true
    expect(screen.active).toBe(true)

    screen.close()

    expect(screen.active).toBe(false)
    expect(Twine.refresh).toHaveBeenCalled()

  it "sets lastSearch on searchEvent", ->
    node = document.createElement("input")
    node.setAttribute("value", "test search")
    event = {target: node}

    screen.searchChange(event)

    expect(screen.lastSearch).toEqual("test search")
    expect(Twine.refresh).toHaveBeenCalled()

  it "filter returns true if the last search matches the input", ->
    screen.lastSearch = "Swift"
    filter = screen.filter("Swift vs Goose")
    expect(filter).toBeTruthy()

  it "filter returns true if the last search matches the input (array)", ->
    screen.lastSearch = "Swift"
    filter = screen.filter(["NADS vs Magma2", "Swift vs Goose"])
    expect(filter).toBeTruthy()

  it "filter returns true when no lastSearch", ->
    screen.lastSearch = ""
    filter = screen.filter("Swift vs Goose")
    expect(filter).toBeTruthy()

  it "filter returns false if the lastSearch doesn't match", ->
    screen.lastSearch = "Goat"
    filter = screen.filter("Swift vs Goose")
    expect(filter).toBeFalsy()

  it "filter isn't fooled by substring team matches", ->
    screen.lastSearch = "Magma"
    filter = screen.filter("Magma2 vs Goose")
    expect(filter).toBeFalsy()

  it "findField finds the field and call pointToField", ->
    spyOn(app, 'pointToField')

    screen.findField("UPI1")

    field = app.pointToField.calls.mostRecent().args[0]
    expect(field.name).toEqual('UPI1')
    expect(app.findText).toEqual("UPI1")

  it "findField returns if field not found", ->
    spyOn(app, 'pointToField')

    screen.findField("Not a valid field")

    expect(app.pointToField).not.toHaveBeenCalled()

  it "findField closes the scheduleScreen", ->
    spyOn(screen, 'close')
    screen.findField("Not a valid field")
    expect(screen.close).toHaveBeenCalled()
