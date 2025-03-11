# Masterserver viewer

ReferenceReader = require './lib/referencereader.coffee'

Ractive.DEBUG = /unminified/.test -> `/*unminified*/`

unless window.EventSource?
  $('#games .status').show()
  return

findIndex = (array, fun) ->
  for item, i in array
    if fun(item)
      return i

compareGames = (a, b) ->
  getWeight = (game) ->
    base = if not game?
      1 # not sure when this happens
    else if game.status == 'lobby'
      30
    else if game.flags.joinAllowed
      20
    else
      10
    base-- if game?.flags.passwordNeeded
    return base * (-new Date(game?.created).valueOf())
  getWeight(a) - getWeight(b)

getTitleImage = (game) ->
  return '' unless game?
  filename = game.scenario.filename
  crc = game.scenario.contentsCRC
  "/images/games/Title.png/#{filename}?hash=#{crc}"

ractive = new Ractive
  el: '#games'
  template: '#games-template'
  data:
    games: []
    status: 'connecting'

    notifications: do ->
      try
        return JSON.parse(localStorage.gameNotifications)
      catch err
        return []

    RR: ReferenceReader
    getTitleImage : getTitleImage

    getTags: (game) ->
      return '' unless game?
      tags = [game.status]
      tags.push (if game.type == 'noleague' then game.type else 'league')
      tags.push 'lzb' if game.flags.joinAllowed
      tags.push 'pw' if game.flags.passwordNeeded
      return tags.join ' '
        
  computed:
    totalPlayers: ->
      games = @get 'games'
      games.reduce ((n, game) -> n + ReferenceReader.getPlayers(game).length), 0

  addGame: (game) ->
    games = @get('games')
    games.unshift game
    # Will be sorted properly on first update.

  updateGame: (game, pred) ->
    games = @get('games')
    i = findIndex games, (g) -> game.id is g.id and pred(g)
    if i?
      @set 'games.'+i, game
      games.sort(compareGames)

  removeGame: (game, pred) ->
    games = @get('games')
    i = findIndex games, (g) -> game.id is g.id and pred(g)
    if i?
      games.splice i, 1
      games.sort(compareGames)

  # Removes the nth notification.
  removeNotification: (n) ->
    @get('notifications').splice n, 1

ractive.on 'toggle-notifications', ->
  nextState = not @get 'showNotifications'
  if nextState
    # Check whether notifications are available.
    unless window.Notification?
      alert "Notifications aren't supported by your browser."
      return
    unless Notification.permission is 'granted'
      Notification.requestPermission (status) ->
        ractive.fire 'toggle-notifications' if status is 'granted'
      return

  @set 'showNotifications', nextState

ractive.on 'add-notification', ->
  query = @get 'newQuery'
  return unless query?.length
  @get('notifications').push {query}
  @set 'newQuery', ''

ractive.observe 'notifications', (newVal) ->
  localStorage.gameNotifications = JSON.stringify(newVal)
, init: false, defer: true

# Checks a single notification query against a game, creating a
# notification on match.
checkNotification = (game) ->
  # Manual currying
  ({query}) ->
    ql = query.toLowerCase()
    title = ReferenceReader.getScenarioTitle(game)
    filename = ReferenceReader.getScenarioFilename(game)
    for str in [
      title
      filename
    ]
      if ~str.toLowerCase().indexOf(ql)
        # Send notification
        n = new Notification title,
          icon: getTitleImage(game)
          body: "Filter: #{query}"
        n.onclick = ->
          location.href = game.eventSource.joinURL(game.id)
        return

eventSources = [
  url: 'https://league.clonkspot.org/game_events'
  joinURL: (id) -> "clonk://league.clonkspot.org:80/?action=query&game_id=#{id}"
,
  url: 'https://league.openclonk.org/game_events'
  joinURL: (id) -> "openclonk://league.openclonk.org:80/league.php?action=query&game_id=#{id}"
]

eventSources.forEach (eventSrc) ->
  # Adds the event source to identify games later.
  transformGame = (game) -> game.eventSource = eventSrc
  ourGame = (game) -> game.eventSource is eventSrc

  events = new EventSource eventSrc.url

  # Init: Replace all our games.
  events.addEventListener 'init', (e) ->
    games = ractive.get('games').filter (g) -> not ourGame(g)
    newGames = JSON.parse(e.data)
    newGames.forEach(transformGame)
    games = games.concat newGames
    ractive.set 'games', games.sort(compareGames)
  , false

  # Create: Add a single new game.
  events.addEventListener 'create', (e) ->
    game = JSON.parse(e.data)
    transformGame(game)
    ractive.addGame game
    ractive.get('notifications').forEach(checkNotification(game))
  , false

  # Update: Change an existing game.
  events.addEventListener 'update', (e) ->
    game = JSON.parse(e.data)
    transformGame(game)
    ractive.updateGame game, ourGame
  , false

  rmGame = (e) ->
    game = JSON.parse(e.data)
    ractive.removeGame game, ourGame

  events.addEventListener 'end', rmGame, false
  events.addEventListener 'delete', rmGame, false

  # XXX: Do something less racy here.
  events.onopen =  -> ractive.set 'status', 'connected'
  events.onerror = -> ractive.set 'status', 'disconnected'

