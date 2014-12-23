# Masterserver viewer

ReferenceReader = require './lib/referencereader.coffee'

unless window.EventSource?
  $('#games .status').show()
  return

findIndex = (array, fun) ->
  for item, i in array
    if fun(item)
      return i

compareGames = (a, b) ->
  getWeight = ({game}) ->
    base = if not game?
      40 # not sure when this happens
    else if game.status == 'lobby'
      10
    else if game.is_join_allowed
      20
    else 
      30
    base++ if game?.is_password_needed
    return base * (Date.now() - game?.date_created)
  getWeight(a) - getWeight(b)

ractive = new Ractive
  el: '#games'
  template: '#games-template'
  data:
    games: []
    status: 'connecting'

    notifications: []

    RR: ReferenceReader

    getTags: (game) ->
      tags = [game.status]
      tags.push (if game.type == 'noleague' then game.type else 'league')
      tags.push 'lzb' if game.is_join_allowed
      tags.push 'pw' if game.is_password_needed
      return tags.join ' '
        
  computed:
    totalPlayers: ->
      games = @get 'games'
      getPlayers = @get 'getPlayers'
      games.reduce ((n, {reference}) -> n + getPlayers(reference).length), 0

  addGame: (game) ->
    games = @get('games')
    games.unshift game
    # Will be sorted properly on first update.

  updateGame: (game) ->
    games = @get('games')
    i = findIndex games, (g) -> game.id is g.id
    if i?
      @set 'games.'+i, game
      games.sort(compareGames)

  removeGame: (game) ->
    games = @get('games')
    i = findIndex games, (g) -> game.id is g.id
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
  @get('notifications').push {query}
  @set 'newQuery', ''

# Checks a single notification query against a game, creating a
# notification on match.
checkNotification = (game) ->
  # Manual currying
  (n) ->
    for str in [
      game.reference['[Reference]'][0]['[Scenario]'][0].Filename
      game.reference['[Reference]'][0].Title
    ]
      if ~str.indexOf(n.query)
        # TODO: Send notification
        new Notification
        return

events = new EventSource '/league/game_events.php'

events.addEventListener 'init', (e) ->
  games = JSON.parse(e.data)
  ractive.set 'games', games.sort(compareGames)
, false

events.addEventListener 'create', (e) ->
  game = JSON.parse(e.data)
  ractive.addGame game
  ractive.get('notifications').forEach(checkNotification(game))
, false

events.addEventListener 'update', (e) ->
  game = JSON.parse(e.data)
  ractive.updateGame game
, false

rmGame = (e) ->
  game = JSON.parse(e.data)
  ractive.removeGame game

events.addEventListener 'end', rmGame, false
events.addEventListener 'delete', rmGame, false

events.onopen =  -> ractive.set 'status', 'connected'
events.onerror = -> ractive.set 'status', 'disconnected'

