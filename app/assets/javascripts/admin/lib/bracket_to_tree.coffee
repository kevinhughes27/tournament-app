window.UT ||= {}

UT.bracketToTree = (bracket) ->
  games = bracket.template.games

  roots = _.filter(games, (g) -> !isNaN(g.uid))
  roots = _.sortBy(roots, (g) -> parseInt(g.uid))

  addNode = (gameUid) ->
    game = _.find(games, (g) -> g.uid == gameUid)

    if game
      addInnerNode(game)
    else
      addLeafNode(gameUid)

  addInnerNode = (game) ->
    label = game.uid

    unless isNaN(label)
      label = parseInt(label).ordinalize()

    node = {
      name: label,
      children: [
        homeChild(game),
        awayChild(game)
      ]
    }

  homeChild = (game) ->
    homeUid = game.home.toString().replace('W', '')
    if game.seed
      addLeafNode(homeUid)
    else
      addNode(homeUid)

  awayChild = (game) ->
    awayUid = game.away.toString().replace('W', '')
    if game.seed
      addLeafNode(awayUid)
    else
      addNode(awayUid)

  addLeafNode = (uid) ->
    klass = if uid.match(/L./) then 'loser' else 'initial'

    return {
      name: uid,
      HTMLclass: klass
    }

  return _.map(roots, (g) -> addNode(g.uid))
