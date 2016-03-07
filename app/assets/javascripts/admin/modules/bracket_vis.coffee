class Admin.BracketVis

  constructor: (@node) ->
    @debug = true

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
    }
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

    if @debug
      vis.on "configChange", =>
        div = $('.vis-configuration-wrapper')[0]
        div.style["height"] = div.getBoundingClientRect().height + "px"

  graphFromBracket: (bracket) ->
    @nodes = []
    @edges = []

    @games = bracket.template.games
    roots = _.filter(@games, (g) -> g.place)
    roots = _.sortBy(roots, (g) -> parseInt(g.place.replace(/[A-Za-z]./, '')))

    _.map(roots, (game) => @_addNode(game.uid, 1))

    return {
      nodes: @nodes
      edges: @edges
    }

  _addNode: (gameUid, level) ->
    game = _.find(@games, (game) -> game.uid == gameUid)

    if game
      @__addInnerNode(game, level)
    else
      @__addLeafNode(gameUid, level)

  __addInnerNode: (game, level) ->
    @nodes.push({
      id: game.uid,
      label: game.place || game.uid,
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

  # graphFromBracket: (bracket) ->
  #   @nodes = []
  #   @edges = []
  #
  #   @bracket = bracket
  #   @games = @bracket.template.games
  #   @pools = _.compact(_.uniq(_.pluck(@games, 'pool')))
  #   @games = _.filter(@games, (g) -> !g.pool)
  #   @games = _.sortBy(@games, (g) -> -g.round)
  #
  #   @_addGameNodes()
  #   @_addLoserNodes()
  #   @_addInitialNodes()
  #
  #   return {
  #     nodes: @nodes
  #     edges: @edges
  #   }
  #
  # _addGameNodes: ->
  #   _.map(@games, (game) =>
  #     gameUid = game.uid
  #
  #     node = {
  #       id: gameUid,
  #       label: game.place || gameUid,
  #       level: @bracket.rounds - game.round
  #     }
  #
  #     if game.place
  #       node.fixed = {y: true}
  #       node.y = parseInt(game.place.replace(/[A-Za-z]./, ''))
  #
  #     @nodes.push(node)
  #
  #     winnerUid = _.find(@games, (g) -> g.home == "W#{gameUid}" || g.away == "W#{gameUid}")?.uid
  #     if winnerUid
  #       @edges.push({
  #         from: gameUid,
  #         to: winnerUid
  #       })
  #   )
  #
  # _addLoserNodes: ->
  #   loserOnlyGames = _.filter(@games, (game) ->
  #     game.home.toString().match("L.") &&
  #     game.away.toString().match("L.")
  #   )
  #
  #   _.map(loserOnlyGames, (game) =>
  #     @nodes.push({
  #       id: game.home,
  #       label: game.home,
  #       level: @bracket.rounds - game.round + 1,
  #       group: 'loser'
  #     })
  #
  #     @nodes.push({
  #       id: game.away,
  #       label: game.away,
  #       level: @bracket.rounds - game.round + 1,
  #       group: 'loser'
  #     })
  #
  #     @edges.push({
  #       from: game.home,
  #       to: game.uid
  #     })
  #
  #     @edges.push({
  #       from: game.away,
  #       to: game.uid
  #     })
  #   )
  #
  # _addInitialNodes: ->
  #   if @pools.length > 0
  #     @__addAfterPoolNodes()
  #   else
  #     @__addSeedNodes()
  #
  # __addAfterPoolNodes: ->
  #   poolRegex = ///(#{@pools.join('|')}\d)///
  #
  #   _.map(@games, (game) =>
  #     gameUid = game.uid
  #
  #     if game.home.match(poolRegex)
  #       @nodes.push({
  #         id: game.home,
  #         label: game.home,
  #         level: @bracket.rounds - game.round + 1,
  #         group: 'initial'
  #       })
  #
  #       @edges.push({
  #         from: game.home,
  #         to: game.uid
  #       })
  #
  #     if game.away.match(poolRegex)
  #       @nodes.push({
  #         id: game.away,
  #         label: game.away,
  #         level: @bracket.rounds - game.round + 1,
  #         group: 'initial'
  #       })
  #
  #       @edges.push({
  #         from: game.away,
  #         to: game.uid
  #       })
  #   )
  #
  # __addSeedNodes: ->
  #   seedGames = _.filter(@games, (game) -> game.seed)
  #
  #   _.map(seedGames, (game) =>
  #     gameUid = game.uid
  #
  #     unless isNaN(parseInt(game.home))
  #       @nodes.push({
  #         id: game.home,
  #         label: game.home,
  #         level: @bracket.rounds - game.round + 1,
  #         group: 'initial'
  #       })
  #
  #       @edges.push({
  #         from: game.home,
  #         to: game.uid
  #       })
  #
  #     unless isNaN(parseInt(game.away))
  #       @nodes.push({
  #         id: game.away,
  #         label: game.away,
  #         level: @bracket.rounds - game.round + 1,
  #         group: 'initial'
  #       })
  #
  #       @edges.push({
  #         from: game.away,
  #         to: game.uid
  #       })
  #   )
