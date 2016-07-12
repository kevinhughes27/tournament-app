class Admin.BracketVis

  options: {
    container: "#bracketGraph",
    levelSeparation:    30,
    siblingSeparation:  15,
    subTeeSeparation:   15,
    rootOrientation: "EAST",
    hideRootNode: true,
    nodeAlign: "CENTER",
    scrollbar: "None",

    node: {
      collapsable: true
    },

    connectors: {
      type: "straight",
      style: {
        "stroke-width": 2,
        "stroke": "#ccc"
      }
    }
  },

  render: (bracket) ->
    options = @options
    nodes = @graphFromBracket(bracket)

    vis = new Treant({
      chart: options,
      nodeStructure: {
        text: 'fake',
        children: nodes
      }
    })

    #$('#bracketVisModal').on 'shown.bs.modal', (e) ->
      #vis.fit()

  graphFromBracket: (bracket) ->
    @games = bracket.template.games
    roots = _.filter(@games, (g) -> !isNaN(g.uid))
    roots = _.sortBy(roots, (g) -> parseInt(g.uid))
    return _.map(roots, (game) => @_addNode(game.uid))

  _addNode: (gameUid) ->
    game = _.find(@games, (game) -> game.uid == gameUid)

    if game
      @__addInnerNode(game)
    else
      @__addLeafNode(gameUid)

  __addInnerNode: (game) ->
    label = game.uid

    unless isNaN(label)
      label = parseInt(label).ordinalize()

    node = {
      text: {
        name: label
      },
      children: [
        @__homeChild(game),
        @__awayChild(game)
      ]
    }

  __homeChild: (game) ->
    homeUid = game.home.toString().replace('W', '')
    if game.seed
      @__addLeafNode(homeUid)
    else
      @_addNode(homeUid)

  __awayChild: (game) ->
    awayUid = game.away.toString().replace('W', '')
    if game.seed
      @__addLeafNode(awayUid)
    else
      @_addNode(awayUid)

  __addLeafNode: (uid) ->
    klass = if uid.match(/L./) then 'loser' else 'initial'

    return {
      text: {
        name: uid
      },
      HTMLclass: klass
    }
