# TwitchTV notification via JSONP API

define ['jquery'], ($) ->
  CHANNEL_URL = 'https://api.twitch.tv/kraken/streams/Nachtfalter89?callback=?'

  # Check whether there's a stream running.
  checkStream = (data) ->
    if data?.stream?.game?.match /clonk/i
      $('header .twitch')
        .slideDown()
        .find('a')
          .attr('href', data.stream.channel.url)

  lastCheck = sessionStorage['twitch.time']
  prev = sessionStorage['twitch.stream']

  # Only check every 5min.
  if prev and lastCheck and Date.now() - lastCheck < 3e5
    checkStream(JSON.parse prev)
  else
    # JSONP request
    $.getJSON(CHANNEL_URL).then (data) ->
      # Cache the result.
      sessionStorage['twitch.time'] = Date.now()
      sessionStorage['twitch.stream'] = JSON.stringify data
      checkStream data
