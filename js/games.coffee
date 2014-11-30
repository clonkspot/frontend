# Masterserver viewer

findIndex = (array, fun) ->
  for item, i in array
    if fun(item)
      return i

unquote = (str) -> str.slice(1, -1)

ractive = new Ractive
  el: '#games'
  template: '#games-template'
  data:
    games: []

    getHostName: (r) ->
      unquote(r['[Reference]'][0]['[Client]'][0].Name)

    getMaxPlayerCount: (r) ->
      r['[Reference]'][0].MaxPlayers ? '?'

    getPlayers: (r) ->
      players = []
      for client in r['[Reference]'][0]['[PlayerInfos]'][0]['[Client]']
        for player in client['[Player]']
          players.push unquote(player.Name)
      return players

  addGame: (game) ->
    @get('games').push game

  updateGame: (game) ->
    games = @get('games')
    i = findIndex games, (g) -> game.id is g.id
    if i?
      games.splice i, 1, game

  removeGame: (game) ->
    games = @get('games')
    i = findIndex games, (g) -> game.id is g.id
    if i?
      games.splice i, 1

events = new EventSource '/league/game_events.php'

events.addEventListener 'init', (e) ->
  games = JSON.parse(e.data)
  ractive.set 'games', games
, false

events.addEventListener 'create', (e) ->
  game = JSON.parse(e.data)
  ractive.addGame game
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

