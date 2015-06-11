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
    g.players.map (p) -> p.name

module.exports = RR
