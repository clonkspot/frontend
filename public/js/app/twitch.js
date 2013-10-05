(function() {
  define(['jquery'], function($) {
    var CHANNEL_URL, checkStream, lastCheck, prev;
    CHANNEL_URL = 'https://api.twitch.tv/kraken/streams/Nachtfalter89?callback=?';
    checkStream = function(data) {
      var _ref, _ref1;
      if (data != null ? (_ref = data.stream) != null ? (_ref1 = _ref.game) != null ? _ref1.match(/clonk/i) : void 0 : void 0 : void 0) {
        return $('header .twitch').slideDown().find('a').attr('href', data.stream.channel.url);
      }
    };
    lastCheck = sessionStorage['twitch.time'];
    prev = sessionStorage['twitch.stream'];
    if (prev && lastCheck && Date.now() - lastCheck < 3e5) {
      return checkStream(JSON.parse(prev));
    } else {
      return $.getJSON(CHANNEL_URL).then(function(data) {
        sessionStorage['twitch.time'] = Date.now();
        sessionStorage['twitch.stream'] = JSON.stringify(data);
        return checkStream(data);
      });
    }
  });

}).call(this);
