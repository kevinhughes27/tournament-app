class Admin.BracketVis

  constructor: (@node) ->
    @debug = false

  options: {
    layout: {
      hierarchical: {
        direction: 'RL',
        sortMethod: 'directed',
        edgeMinimization: false,
        levelSeparation: 228
      }
    },
    physics: {
      enabled: true
    },
    interaction: {
      dragNodes: false
    },
    groups: {
      initial: {color: {border: 'white', background: 'white'}},
      loser: {color: {background: 'white'}},
    },
    nodes: {
      font: {size: 42}
    },
    edges: {
      color: {color: '#848484'}
    }
  }

  render: (bracket) ->
    options = @options

    if @debug
      _.extend(options, {configure: {
        enabled: true,
        filter: 'layout, physics',
        container: document.getElementById('visConfigure'),
        showButton: false
      }})

    data = @graphFromBracket(bracket)
    vis = new window.vis.Network(@node, data, options)

    $('#bracketVisModal').on 'shown.bs.modal', (e) ->
      vis.fit()

    if @debug
      vis.on "configChange", =>
        div = $('.vis-configuration-wrapper')[0]
        div.style["height"] = div.getBoundingClientRect().height + "px"

  graphFromBracket: (bracket) ->
    @nodes = []
    @edges = []

    @games = bracket.template.games
    roots = _.filter(@games, (g) -> !isNaN(g.uid))
    roots = _.sortBy(roots, (g) -> parseInt(g.uid))

    _.map(roots, (game) => @_addNode(game.uid, 1))

    return {
      nodes: @nodes
      edges: @edges
    }

  _addNode: (gameUid, level) ->
    game = _.find(@games, (game) -> game.uid == gameUid)

    if game && !game.seed
      @__addInnerNode(game, level)
    else
      @__addLeafNode(gameUid, level)

  __addInnerNode: (game, level) ->
    label = game.uid

    unless isNaN(label)
      label = parseInt(label).ordinalize()

    @nodes.push({
      id: game.uid,
      label: label,
      level: level
    })

    homeUid = game.home.toString().replace('W', '')
    @edges.push({
      from: game.uid,
      to: homeUid
    })
    @_addNode(homeUid, level+1)

    awayUid = game.away.toString().replace('W', '')
    @edges.push({
      from: game.uid,
      to: awayUid
    })
    @_addNode(awayUid, level+1)

  __addLeafNode: (uid, level) ->
    group = if uid.match(/L./) then 'loser' else 'initial'

    @nodes.push({
      id: uid,
      label: uid,
      level: level
      group: group
    })
