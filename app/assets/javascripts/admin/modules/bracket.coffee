class Admin.Bracket

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
    @bracketVis ||= new Admin.BracketVis(@$bracketGraphNode[0])
    @bracketVis.render(bracket)

TEMPLATES =
  description: """
    <p>
      <strong><%= bracket.name %>
      <% if(bracket.tagline) { %>
        : <%= bracket.tagline %></strong>
      <% } %>
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
