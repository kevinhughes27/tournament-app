class Admin.Bracket

  constructor: (node, bracketName) ->
    @descTemplate = _.template(TEMPLATES.description)
    @poolsTemplate = _.template(TEMPLATES.pools)
    @noPoolsTemplate = _.template(TEMPLATES.no_pools)

    @$node = $(node)
    @$bracketDescNode = @$node.find('#bracketDescription')
    @$bracketPoolsNode = @$node.find('#bracketPools')
    @$bracketGraphNode = @$node.find('#bracketGraph')

  render: (bracketName) ->
    bracket = Admin.BracketDb.find(bracketName)

    if bracket
      @$node.fadeIn()
      @renderDescription(bracket)
      @renderPools(bracket)
      @renderBracket(bracket)
    else
      @$node.fadeOut()

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
      teamsByPool = {}
      gamesByPool = _.groupBy(games, 'pool')

      _.each(gamesByPool, (games, pool) ->
        homeTeams = _.pluck(games, 'home')
        awayTeams = _.pluck(games, 'away')
        teams = _.union(homeTeams, awayTeams)
        teamsByPool[pool] = _.sortBy(teams, (t) -> t)
      )

      @$bracketPoolsNode.append(
        @poolsTemplate({teamsByPool: teamsByPool})
      )
    else
      @$bracketPoolsNode.append(
        @noPoolsTemplate()
      )

  renderBracket: (bracket) ->
    @bracketVis ||= new Admin.BracketVis(@$bracketGraphNode[0])
    @bracketVis.render(bracket)

TEMPLATES =
  description: """
    <p>
      <strong><%= bracket.name %></strong>
    </p>
    <p>
      <%= bracket.description %>
    </p>
  """
  pools: """
    <div class="row">
      <% _.each(teamsByPool, function(teams, pool) { %>
        <div class="col-md-6">
          <table class="table table-bordered table-striped table-hover table-condensed">
            <thead>
              <tr>
                <th>Pool <%= pool %></th>
              </tr>
            </thead>

            <tbody>
              <% _.each(teams, function(team) { %>
                <tr>
                  <td><%= team %></td>
                </tr>
              <% }) %>
            </tbody>
          </table>
        </div>
      <% }) %>
    </div>
  """
  no_pools: """
    <div class="blank-slate" style="margin-top: 60px;">
      <p>No Pool Games</p>
    </div>
  """
