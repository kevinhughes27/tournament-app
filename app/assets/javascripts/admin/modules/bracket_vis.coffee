class Admin.BracketVis

  constructor: (node, bracketName) ->
    @descTemplate = _.template(TEMPLATES.description)
    @poolsTemplate = _.template(TEMPLATES.pool)

    @$bracketDescNode = $(node).find('#bracketDescription')
    @$bracketPoolsNode = $(node).find('#bracketPools')
    @$bracketGraphNode = $(node).find('#bracketGraph')

    @render(bracketName)

  render: (bracketName) ->
    bracket = _.find(Admin.BracketDb.BRACKETS, (bracket) -> bracket.name == bracketName)

    if bracket
      @renderDescription(bracket)
      @renderPools(bracket)
      @renderBracket(bracket)
    else
      # render some blank slate

  renderDescription: (bracket) ->
    @$bracketDescNode.empty()
    @$bracketDescNode.append(
      @descTemplate({bracket: bracket})
    )

  renderPools: (bracket) ->
    @$bracketPoolsNode.empty()

    games = bracket.template.games
    games = _.filter(games, 'pool')

    if games.length > 0
      gamesByPool = _.groupBy(games, 'pool')

      @$bracketPoolsNode.append(
        @poolsTemplate({gamesByPool: gamesByPool})
      )
    else
      # some blank slate

  renderBracket: (bracket) ->
    data = @graphFromBracket(bracket)
    vis = new window.vis.Network(@$bracketGraphNode[0], data, @options)

  options: {
      interaction: {
        dragNodes: false
      },
      layout: {
        hierarchical: {
          direction: 'RL',
          levelSeparation: 200
        }
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

  graphFromBracket: (bracket) ->
    @nodes = []
    @edges = []

    @bracket = bracket
    @games = @bracket.template.games
    @pools = _.compact(_.uniq(_.pluck(@games, 'pool')))
    @games = _.filter(@games, (g) -> !g.pool)
    @games = _.sortBy(@games, (g) -> -g.round)

    @_addGameNodes()
    @_addLoserNodes()
    @_addInitialNodes()

    return {
      nodes: @nodes
      edges: @edges
    }

  _addGameNodes: ->
    _.map(@games, (game) =>
      gameUid = game.uid

      @nodes.push({
        id: gameUid,
        label: game.place || gameUid,
        level: @bracket.rounds - game.round + 1
      })

      winnerUid = _.find(@games, (g) -> g.home == "W#{gameUid}" || g.away == "W#{gameUid}")?.uid
      @edges.push({
        from: gameUid,
        to: winnerUid
      })
    )

  _addLoserNodes: ->
    loserOnlyGames = _.filter(@games, (game) ->
      game.home.toString().match("L.") &&
      game.away.toString().match("L.")
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

  _addInitialNodes: ->
    if @pools.length > 0
      @__addAfterPoolNodes()
    else
      @__addSeedNodes()

  __addAfterPoolNodes: ->
    poolRegex = ///(#{@pools.join('|')}\d)///

    _.map(@games, (game) =>
      gameUid = game.uid

      if game.home.match(poolRegex)
        @nodes.push({
          id: game.home,
          label: game.home,
          level: @bracket.rounds - game.round + 2,
          group: 'initial'
        })

        @edges.push({
          from: game.home,
          to: game.uid
        })

      if game.away.match(poolRegex)
        @nodes.push({
          id: game.away,
          label: game.away,
          level: @bracket.rounds - game.round + 2,
          group: 'initial'
        })

        @edges.push({
          from: game.away,
          to: game.uid
        })
    )

  __addSeedNodes: ->
    seedGames = _.filter(@games, (game) -> game.seed)

    _.map(seedGames, (game) =>
      gameUid = game.uid

      unless isNaN(parseInt(game.home))
        @nodes.push({
          id: game.home,
          label: game.home,
          level: @bracket.rounds - game.round + 2,
          group: 'initial'
        })

        @edges.push({
          from: game.home,
          to: game.uid
        })

      unless isNaN(parseInt(game.away))
        @nodes.push({
          id: game.away,
          label: game.away,
          level: @bracket.rounds - game.round + 2,
          group: 'initial'
        })

        @edges.push({
          from: game.away,
          to: game.uid
        })
    )

TEMPLATES =
  description: """
    <p>
      <strong><%= bracket.name %>: <%= bracket.sub_title %></strong>
    </p>
    <p>
      <%= bracket.description %>
    </p>
  """
  pool: """
    <% _.each(gamesByPool, function(pool, name) { %>
      <table class="table table-bordered table-striped table-hover table-condensed">
        <thead>
          <tr>
            <th>Pool <%= name %></th>
          </tr>
        </thead>

        <tbody>
          <% _.each(pool, function(game) { %>
            <tr>
              <td><%= game.home %> vs <%= game.away %></td>
            </tr>
          <% }) %>
        </tbody>
      </table>
    <% }) %>
  """
