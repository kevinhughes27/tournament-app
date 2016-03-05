class Admin.BracketVis

  constructor: (node, bracketName) ->
    @node = node
    @draw(bracketName)

  draw: (bracketName) ->
    bracket = _.find(Admin.BracketDb.BRACKETS, (bracket) -> bracket.name == bracketName)

    if bracket
      data = @graphFromBracket(bracket)
      vis = new window.vis.Network(@node, data, @options)
    else
      # render some blank slate

  options: {
      layout: {
        hierarchical: {
          direction: 'RL',
          levelSeparation: 200
        }
      },
      groups: {
        first: {color: {border: 'white', background: 'white'}},
        loser: {color: {background: 'white'}},
      },
      nodes: {
        font: {size: 42}
      }
      edges: {
        color: {color: '#848484'}
      }
    }

  graphFromBracket: (bracket) ->
    @nodes = []
    @edges = []

    @bracket = bracket
    @games = @bracket.template.games
    @games = _.filter(@games, (g) -> !g.pool)
    @games = _.sortBy(@games, (g) -> -g.round)

    @_addGameNodes()
    @_addLoserNodes()
    @_addFirstRoundNodes()

    return {
      nodes: @nodes
      edges: @edges
    }

  _addGameNodes: ->
    _.map(@games, (game) =>
      gameUid = game.uid

      @nodes.push({
        id: gameUid,
        label: gameUid,
        level: @bracket.rounds - game.round + 1
      })

      winnerUid = _.find(@games, (g) -> g.home == "w#{gameUid}" || g.away == "w#{gameUid}")?.uid
      @edges.push({
        from: gameUid,
        to: winnerUid
      })
    )

  _addLoserNodes: ->
    loserOnlyGames = _.filter(@games, (game) ->
      game.home.toString().match("l.") &&
      game.away.toString().match("l.")
    )

    _.map(loserOnlyGames, (game) =>
      @nodes.push({
        id: game.home,
        label: game.home,
        level: @bracket.rounds - game.round + 2,
        group: 'loser'
      })

      @nodes.push({
        id: game.away,
        label: game.away,
        level: @bracket.rounds - game.round + 2,
        group: 'loser'
      })

      @edges.push({
        from: game.home,
        to: game.uid
      })

      @edges.push({
        from: game.away,
        to: game.uid
      })
    )

  _addFirstRoundNodes: ->
    firstRoundGames = _.filter(@games, (game) -> game.round == 1)

    _.map(firstRoundGames, (game) =>
      gameUid = game.uid

      @nodes.push({
        id: game.home,
        label: game.home,
        level: @bracket.rounds - game.round + 2,
        group: 'first'
      })

      @nodes.push({
        id: game.away,
        label: game.away,
        level: @bracket.rounds - game.round + 2,
        group: 'first'
      })

      @edges.push({
        from: game.home,
        to: game.uid
      })

      @edges.push({
        from: game.away,
        to: game.uid
      })
    )
