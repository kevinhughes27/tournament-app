describe 'SubmitScoreScreen', ->
  app = null
  screen = null

  beforeEach ->
    app = {
      teams: [{name: 'Swift', id: 14}, {name: 'Goose'}, {name: 'Magma'}]
    }

    screen = new App.SubmitScoreScreen(app)
    spyOn(Twine, 'refresh')
    spyOn(Twine, 'refreshImmediately')

  it "show sets active and calls Twine.refresh", ->
    expect(screen.active).toBe(false)

    screen.show()

    expect(screen.active).toBe(true)
    expect(Twine.refresh).toHaveBeenCalled()

  it "show sets location hash", ->
    screen.show()
    expect(window.location.hash).toEqual("#submit-score")

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

  it "filter returns false when no lastSearch", ->
    screen.lastSearch = ""
    filter = screen.filter("Swift vs Goose")
    expect(filter).toBeFalsy()

  it "filter returns false if the lastSearch doesn't match", ->
    screen.lastSearch = "Goat"
    filter = screen.filter("Swift vs Goose")
    expect(filter).toBeFalsy()

  it "filter isn't fooled by substring team matches", ->
    screen.lastSearch = "Magma"
    filter = screen.filter("Magma2 vs Goose")
    expect(filter).toBeFalsy()

  it "vsTeam returns undefined unless one of the teams is searched", ->
    screen.lastSearch = "Swift"
    team = screen.vsTeam("Goose", "Magma")
    expect(team).toBe(undefined)

  it "vsTeam returns the opponent of the requested team (team is away)", ->
    screen.lastSearch = "Swift"
    team = screen.vsTeam("Goose", "Swift")
    expect(team).toEqual("Goose")

  it "vsTeam returns the opponent of the requested team (team is home)", ->
    screen.lastSearch = "Swift"
    team = screen.vsTeam("Swift", "Goose")
    expect(team).toEqual("Goose")

  it "showForm sets the game and team data and shows the form", ->
    screen.lastSearch = "Swift"
    expect(screen.formActive).toBe(false)
    spyOn(screen, '_prepareForm')

    screen.showForm(27, 'Swift', 'Goose')

    expect(screen.formActive).toBe(true)
    expect(screen._prepareForm).toHaveBeenCalledWith('Swift', 'Goose', 27, 14)
    expect(Twine.refresh).toHaveBeenCalled()

  it "closeForm closes the form", ->
    screen.formActive = true

    screen.closeForm()

    expect(screen.formActive).toBe(false)
    expect(Twine.refresh).toHaveBeenCalled()

  it "submitForm makes an ajax request and shows success when done", ->
    spyOn($, 'ajax').and.callFake( (params) -> params.complete({}) )
    spyOn(screen, '_submitComplete').and.callFake( (form) -> return true )
    screen.active = true
    screen.formActive = true

    screen.submitScore({})

    expect(screen.successActive).toBe(true)
    expect(Twine.refreshImmediately).toHaveBeenCalled()
