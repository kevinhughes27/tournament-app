class Admin.BracketVis

  constructor: (node, bracketName) ->
    @node = node
    @draw(bracketName)

  draw: (bracketName) ->
    data = @graphFromBracket(bracketName)
    #data = @getScaleFreeNetwork(25, 4)
    vis = new window.vis.Network(@node, data, @options)

  options: {
      layout: {
        hierarchical: {
          direction: 'RL'
        }
      }
    }

  # graphFromBracket: (bracketName) ->
  #   @bracket = _.find(Admin.BracketDb.BRACKETS, (bracket) -> bracket.name == bracketName)
  #   @games = @bracket.template.games
  #   @nodes = []
  #   @edges = []
  #
  #   finalGames = _.filter(@games, (game) => game.round == @bracket.rounds)
  #   _.map(finalGames, (game) => @_processTree(game.uid))
  #
  #   return {
  #     nodes: @nodes
  #     edges: @edges
  #   }

  # _processTree: (gameUid) ->
  #   game = _.find(@games, (game) -> game.uid == gameUid)
  #
  #   homeUid = game.home.toString().replace(/(w)/, '')
  #   awayUid = game.away.toString().replace(/(w)/, '')
  #
  #   @nodes.push({
  #     id: homeUid,
  #     label: homeUid,
  #     level: @bracket.rounds - game.round + 1,
  #     group: 'entry'
  #   })
  #
  #   @nodes.push({
  #     id: awayUid,
  #     label: awayUid,
  #     level: @bracket.rounds - game.round + 1,
  #     group: 'entry'
  #   })
  #
  #   return if game.round == 1
  #
  #   @edges.push({
  #     from: homeUid,
  #     to: game.uid
  #   })
  #
  #   @edges.push({
  #     from: awayUid,
  #     to: game.uid
  #   })
  #
  #   homeUid = homeUid.replace(/(l)/, '')
  #   awayUid = awayUid.replace(/(l)/, '')
  #
  #   @_processTree(homeUid)
  #   @_processTree(awayUid)

  graphFromBracket: (bracketName) ->
    nodes = []
    edges = []

    bracket = _.find(Admin.BracketDb.BRACKETS, (bracket) -> bracket.name == bracketName)
    games = bracket.template.games
    games = _.sortBy(games, (g) -> -g.round)

    _.map(games, (game) ->
      gameUid = game.uid

      nodes.push({
        id: gameUid,
        label: gameUid,
        level: bracket.rounds - game.round + 1
      })

      winnerUid = _.find(games, (g) -> g.home == "w#{gameUid}" || g.away == "w#{gameUid}")?.uid

      edges.push({
        from: gameUid,
        to: winnerUid
      })
    )

    # loser only nodes
    loserOnlyGames = _.filter(games, (game) ->
      game.home.toString().match("l.") &&
      game.away.toString().match("l.")
    )

    _.map(loserOnlyGames, (game) ->
      nodes.push({
        id: game.home,
        label: game.home,
        level: bracket.rounds - game.round + 2,
        group: 'entry'
      })

      nodes.push({
        id: game.away,
        label: game.away,
        level: bracket.rounds - game.round + 2,
        group: 'entry'
      })

      edges.push({
        from: game.home,
        to: game.uid
      })

      edges.push({
        from: game.away,
        to: game.uid
      })
    )

    return {
      nodes: nodes
      edges: edges
    }

  # getScaleFreeNetwork: (nodeCount) ->
  #   `var to`
  #   `var from`
  #   nodes = []
  #   edges = []
  #   connectionCount = []
  #   # randomly create some nodes and edges
  #   i = 0
  #   while i < nodeCount
  #     nodes.push
  #       id: i
  #       label: String(i)
  #     connectionCount[i] = 0
  #     # create edges in a scale-free-network way
  #     if i == 1
  #       from = i
  #       to = 0
  #       edges.push
  #         from: from
  #         to: to
  #       connectionCount[from]++
  #       connectionCount[to]++
  #     else if i > 1
  #       conn = edges.length * 2
  #       rand = Math.floor(Math.random() * conn)
  #       cum = 0
  #       j = 0
  #       while j < connectionCount.length and cum < rand
  #         cum += connectionCount[j]
  #         j++
  #       from = i
  #       to = j
  #       edges.push
  #         from: from
  #         to: to
  #       connectionCount[from]++
  #       connectionCount[to]++
  #     i++
  #   {
  #     nodes: nodes
  #     edges: edges
  #   }
