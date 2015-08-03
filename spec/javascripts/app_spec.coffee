describe 'App', ->
  app = null
  fields = [{name: 'UPI1'}]
  teams = [{name: 'Swift'}]
  games = []

  beforeEach ->
    app = new TournamentApp.App(
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
