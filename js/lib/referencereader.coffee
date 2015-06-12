# Reads information out of the reference JSON structure.

RR =
  getScenarioTitle: (g) ->
    g.title
      .replace(/<c [0-9a-f]{6}>|<\/c>/g, '')
      .replace(/<\/?i>/g, '')

  getScenarioFilename: (g) ->
    g.scenario.filename.replace(/\\/g, '/')

  getMaxPlayerCount: (g) ->
    g.maxPlayers ? '?'

  getPlayers: (g) ->
    players = g.players?.map (p) -> p.name
    players ? []

RR.getPlayers.default = []

# Don't throw an error when the game does not exist.
for name, func of RR
  do (func) ->
    exports[name] = (g) -> if g? then func(g) else func.default ? ''
