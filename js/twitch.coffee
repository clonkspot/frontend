# TwitchTV notification via JSONP API

CHANNEL_URL = 'https://api.twitch.tv/kraken/streams/Nachtfalter89?callback=?'

# JSONP request
$.getJSON(CHANNEL_URL).then (data) ->
  # Check whether there's a stream running.
  if data?.stream?.game?.match /clonk/i
    $('header .twitch')
      .slideDown()
      .find('a')
        .attr('href', data.stream.channel.url)
