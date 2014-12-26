# Reads information out of the reference JSON structure.

module.exports =
  getScenarioTitle: (r) ->
    r['[Reference]'][0].Title
      .replace(/<c [0-9a-f]{6}>|<\/c>/g, '')
      .replace(/<\/?i>/g, '')

  getScenarioFilename: (r) ->
    r['[Reference]'][0]['[Scenario]'][0].Filename.replace(/\\/g, '/')

  getScenarioCRC: (r) ->
    r['[Reference]'][0]['[Scenario]'][0].ContentsCRC

  getHostName: (r) ->
    r['[Reference]'][0]['[Client]'][0].Name

  getMaxPlayerCount: (r) ->
    r['[Reference]'][0].MaxPlayers ? '?'

  getPlayers: (r) ->
    players = []
    clients = r['[Reference]'][0]['[PlayerInfos]']?[0]['[Client]']
    return players unless clients?
    for client in clients
      array = client['[Player]']
      continue unless array?
      for player in array
        unless player.Flags? and ~player.Flags.indexOf('Removed')
          players.push player.Name
    return players
