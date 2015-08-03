describe 'SubmitScoreScreen', ->
  screen = null

  beforeEach ->
    screen = new TournamentApp.SubmitScoreScreen()
    spyOn(Twine, 'refresh')

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
